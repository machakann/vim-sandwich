let s:suite = themis#suite('textobj-sandwich: auto:')

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
  silent! ounmap iib
  silent! ounmap aab
  silent! nunmap sd
  silent! xunmap sd
endfunction
"}}}
function! s:suite.after() abort "{{{
  call s:suite.before_each()
endfunction
"}}}

" Filter
function! s:suite.filter_filetype() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'filetype': ['vim']},
        \   {'buns': ['{', '}'], 'filetype': ['all']},
        \ ]

  " #1
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '()', 'failed at #1')

  " #2
  call setline('.', '{foo}')
  normal 02ldib
  call g:assert.equals(getline('.'), '{}', 'failed at #2')

  set filetype=vim

  " #3
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #3')

  " #4
  call setline('.', '{foo}')
  normal 02ldib
  call g:assert.equals(getline('.'), '{}', 'failed at #4')
endfunction
"}}}
function! s:suite.filter_kind() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \ ]

  " #5
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '()', 'failed at #5')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['query']},
        \ ]

  " #6
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '()', 'failed at #6')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['auto']},
        \ ]

  " #7
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #7')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['textobj']},
        \ ]

  " #8
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #8')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['all']},
        \ ]

  " #9
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #9')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']']},
        \ ]

  " #10
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #10')

  " #11
  call setline('.', '([foo])')
  normal 03lvibd
  call g:assert.equals(getline('.'), '([])', 'failed at #11')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['o']},
        \ ]

  " #12
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #12')

  " #13
  call setline('.', '([foo])')
  normal 03lvibd
  call g:assert.equals(getline('.'), '()', 'failed at #13')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['x']},
        \ ]

  " #14
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '()', 'failed at #14')

  " #15
  call setline('.', '([foo])')
  normal 03lvibd
  call g:assert.equals(getline('.'), '([])', 'failed at #15')
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

  " #16
  call setline('.', '(foo)')
  normal 0dib
  call g:assert.equals(getline('.'), '()', 'failed at #16')

  " #17
  call setline('.', '[foo]')
  normal 0dib
  call g:assert.equals(getline('.'), '[]', 'failed at #17')

  " #18
  call setline('.', '{foo}')
  normal 0dib
  call g:assert.equals(getline('.'), '{foo}', 'failed at #18')
endfunction
"}}}

function! s:suite.i_o_default_recipes() abort "{{{
  " #19
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #19')

  " #20
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #20')

  " #21
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #21')

  " #22
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #22')

  " #23
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #23')

  " #24
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #24')
endfunction
"}}}
function! s:suite.i_o_nest() abort  "{{{
  " #25
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #25')

  " #26
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'a', 'failed at #26')

  " #27
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #27')

  " #28
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #28')

  " #29
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #29')

  " #30
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #30')

  " #31
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #31')

  " #32
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #32')

  " #33
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'cc', 'failed at #33')

  " #34
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'cc', 'failed at #34')

  " #35
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'cc', 'failed at #35')

  " #36
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'cc', 'failed at #36')

  " #37
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #37')

  " #38
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #38')

  " #39
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #39')

  " #40
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #40')

  " #41
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #41')

  " #42
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #42')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #43
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #43')

  " #44
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #44')

  " #45
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #45')

  " #46
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #46')

  " #47
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #47')

  " #48
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'bb', 'failed at #48')

  " #49
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'bb', 'failed at #49')

  " #50
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'bb', 'failed at #50')

  " #51
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'bb', 'failed at #51')

  " #52
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'bb', 'failed at #52')

  " #53
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'bb', 'failed at #53')

  " #54
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'bb', 'failed at #54')

  " #55
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'bb', 'failed at #55')

  " #56
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #56')

  " #57
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #57')

  " #58
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #58')

  " #59
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #59')

  " #60
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #60')
endfunction
"}}}
function! s:suite.i_o_no_nest() abort "{{{
  " #61
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #61')

  " #62
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'a', 'failed at #62')

  " #63
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #63')

  " #64
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa', 'failed at #64')

  " #65
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa', 'failed at #65')

  " #66
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'aa', 'failed at #66')

  " #67
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'bb', 'failed at #67')

  " #68
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'bb', 'failed at #68')

  " #69
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'cc', 'failed at #69')

  " #70
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'cc', 'failed at #70')

  " #71
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'cc', 'failed at #71')

  " #72
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'cc', 'failed at #72')

  " #73
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'bb', 'failed at #73')

  " #74
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'bb', 'failed at #74')

  " #75
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'aa', 'failed at #75')

  " #76
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'aa', 'failed at #76')

  " #77
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'aa', 'failed at #77')

  " #78
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'aa', 'failed at #78')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #79
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #79')

  " #80
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa', 'failed at #80')

  " #81
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa', 'failed at #81')

  " #82
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'aa', 'failed at #82')

  " #83
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'aa', 'failed at #83')

  " #84
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'aa', 'failed at #84')

  " #85
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'aa', 'failed at #85')

  " #86
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'aa', 'failed at #86')

  " #87
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'bb', 'failed at #87')

  " #88
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'bb', 'failed at #88')

  " #89
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'cc', 'failed at #89')

  " #90
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'cc', 'failed at #90')

  " #91
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'cc', 'failed at #91')

  " #92
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'cc', 'failed at #92')

  " #93
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'cc', 'failed at #93')

  " #94
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'cc', 'failed at #94')

  " #95
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyib
  call g:assert.equals(@@, 'cc', 'failed at #95')

  " #96
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyib
  call g:assert.equals(@@, 'cc', 'failed at #96')
endfunction
"}}}
function! s:suite.i_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #97
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'bb', 'failed at #97')
endfunction
"}}}
function! s:suite.i_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #98
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #98')

  " #99
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #99')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #100
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #100')

  " #101
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #101')

  " #102
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #102')

  " #103
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $yib
  call g:assert.equals(@@, '', 'failed at #103')
endfunction
"}}}
function! s:suite.i_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #104
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #104')

  " #105
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #105')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #106
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #106')

  " #107
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #107')
endfunction
"}}}
function! s:suite.i_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #108
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #108')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #109
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'fooa', 'failed at #109')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #110
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, "''foo''", 'failed at #110')
endfunction
"}}}
function! s:suite.i_o_option_quoteescape() abort  "{{{
  " #111
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa\"bb', 'failed at #111')
endfunction
"}}}
function! s:suite.i_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #112
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #112')

  %delete

  " #113
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\naa\n", 'failed at #113')

  %delete

  " #114
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #114')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #115
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #115')

  %delete

  " #116
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #116')

  %delete

  " #117
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #117')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #118
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #118')

  %delete

  " #119
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyib
  call g:assert.equals(@@, "\naa\n", 'failed at #119')

  %delete

  " #120
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #120')
endfunction
"}}}
function! s:suite.i_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #121
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #121')

  " #122
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #122')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #123
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #123')

  " #124
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #124')
endfunction
"}}}
function! s:suite.i_o_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #125
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #125')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #126
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #126')

  highlight link TestParen Special

  " #127
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #127')
endfunction
"}}}
function! s:suite.i_o_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #128
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'bar', 'failed at #128')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #129
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #129')

  highlight link TestParen Special

  " #130
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'bar', 'failed at #130')
endfunction
"}}}
function! s:suite.i_o_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}, {'buns': ['"', '"']}]

  """ 1
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #131
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #131')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #132
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #132')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #133
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #133')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #134
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #134')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #135
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #135')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #136
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #136')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #137
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '%s', 'failed at #137')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #138
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #138')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #139
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #139')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #140
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #140')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #141
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '%s', 'failed at #141')
endfunction
"}}}
function! s:suite.i_o_option_skip_breaking() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #142
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\nfoo\n", 'failed at #142')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'skip_break', 1)
  " #143
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "foo", 'failed at #143')
endfunction
"}}}
function! s:suite.i_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  " #144
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'b"c', 'failed at #144')

  " #145
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'aa(b', 'failed at #145')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #146
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, "foo", 'failed at #146')

  " #147
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, "foo''bar", 'failed at #147')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #148
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'oobarbaz', 'failed at #148')

  " #149
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'bar', 'failed at #149')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #150
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #150')

  " #151
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #151')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #152
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #152')

  " #153
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #153')
endfunction
"}}}

function! s:suite.i_x_default_recipes() abort "{{{
  " #154
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #154')

  " #155
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #155')

  " #156
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #156')

  " #157
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #157')

  " #158
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #158')

  " #159
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #159')
endfunction
"}}}
function! s:suite.i_x_nest() abort  "{{{
  " #160
  call setline('.', '()')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #160')

  " #161
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'a', 'failed at #161')

  " #162
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #162')

  " #163
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #163')

  " #164
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #164')

  " #165
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #165')

  " #166
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #166')

  " #167
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #167')

  " #168
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'cc', 'failed at #168')

  " #169
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'cc', 'failed at #169')

  " #170
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'cc', 'failed at #170')

  " #171
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'cc', 'failed at #171')

  " #172
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #172')

  " #173
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #173')

  " #174
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #174')

  " #175
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #175')

  " #176
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #176')

  " #177
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #177')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #178
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #178')

  " #179
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #179')

  " #180
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #180')

  " #181
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #181')

  " #182
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #182')

  " #183
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb', 'failed at #183')

  " #184
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'bb', 'failed at #184')

  " #185
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'bb', 'failed at #185')

  " #186
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'bb', 'failed at #186')

  " #187
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'bb', 'failed at #187')

  " #188
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb', 'failed at #188')

  " #189
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb', 'failed at #189')

  " #190
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'bb', 'failed at #190')

  " #191
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #191')

  " #192
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #192')

  " #193
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #193')

  " #194
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #194')

  " #195
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #195')
endfunction
"}}}
function! s:suite.i_x_no_nest() abort "{{{
  " #196
  call setline('.', '""')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '"', 'failed at #196')

  " #197
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'a', 'failed at #197')

  " #198
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #198')

  " #199
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa', 'failed at #199')

  " #200
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa', 'failed at #200')

  " #201
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa', 'failed at #201')

  " #202
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'bb', 'failed at #202')

  " #203
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb', 'failed at #203')

  " #204
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'cc', 'failed at #204')

  " #205
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'cc', 'failed at #205')

  " #206
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'cc', 'failed at #206')

  " #207
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'cc', 'failed at #207')

  " #208
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb', 'failed at #208')

  " #209
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb', 'failed at #209')

  " #210
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'aa', 'failed at #210')

  " #211
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa', 'failed at #211')

  " #212
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa', 'failed at #212')

  " #213
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa', 'failed at #213')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #214
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #214')

  " #215
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa', 'failed at #215')

  " #216
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa', 'failed at #216')

  " #217
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa', 'failed at #217')

  " #218
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'aa', 'failed at #218')

  " #219
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'aa', 'failed at #219')

  " #220
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'aa', 'failed at #220')

  " #221
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'aa', 'failed at #221')

  " #222
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'bb', 'failed at #222')

  " #223
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'bb', 'failed at #223')

  " #224
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'cc', 'failed at #224')

  " #225
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'cc', 'failed at #225')

  " #226
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'cc', 'failed at #226')

  " #227
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'cc', 'failed at #227')

  " #228
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'cc', 'failed at #228')

  " #229
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'cc', 'failed at #229')

  " #230
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lviby
  call g:assert.equals(@@, 'cc', 'failed at #230')

  " #231
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lviby
  call g:assert.equals(@@, 'cc', 'failed at #231')
endfunction
"}}}
function! s:suite.i_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #232
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bb', 'failed at #232')
endfunction
"}}}
function! s:suite.i_x_selected_area_extending() abort  "{{{
  " #233
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcviby
  call g:assert.equals(@@, 'cc', 'failed at #233')

  " #234
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvibiby
  call g:assert.equals(@@, 'bb{cc}bb', 'failed at #234')

  " #235
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvibibiby
  call g:assert.equals(@@, 'aa[bb{cc}bb]aa', 'failed at #235')
endfunction
"}}}
function! s:suite.i_x_blockwise_visual() abort  "{{{
  " #236
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>iby"
  call g:assert.equals(@@, " \na\n ", 'failed at #236')

  %delete

  " #237
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jiby"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #237')

  %delete

  " #238
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joiby"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #238')

  %delete

  " #239
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jiby"
  call g:assert.equals(@@, "aa)\nbb)\nccc", 'failed at #239')

  %delete

  " #240
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joiby"
  call g:assert.equals(@@, "aaa\nbb)\ncc)", 'failed at #240')
endfunction
"}}}
function! s:suite.i_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #241
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #241')

  " #242
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '2', 'failed at #242')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #243
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '1', 'failed at #243')

  " #244
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #244')

  " #245
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '2', 'failed at #245')

  " #246
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $viby
  call g:assert.equals(@@, '3', 'failed at #246')
endfunction
"}}}
function! s:suite.i_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #247
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #247')

  " #248
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '8', 'failed at #248')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #249
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '\', 'failed at #249')

  " #250
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #250')
endfunction
"}}}
function! s:suite.i_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #251
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #251')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #252
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'fooa', 'failed at #252')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #253
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "''foo''", 'failed at #253')
endfunction
"}}}
function! s:suite.i_x_option_quoteescape() abort  "{{{
  " #254
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa\"bb', 'failed at #254')
endfunction
"}}}
function! s:suite.i_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #255
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #255')

  %delete

  " #256
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\naa\n", 'failed at #256')

  %delete

  " #257
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #257')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #258
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #258')

  %delete

  " #259
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #259')

  %delete

  " #260
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #260')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #261
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #261')

  %delete

  " #262
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjviby
  call g:assert.equals(@@, "\naa\n", 'failed at #262')

  %delete

  " #263
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #263')
endfunction
"}}}
function! s:suite.i_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #264
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #264')

  " #265
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #265')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #266
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #266')

  " #267
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '{', 'failed at #267')

endfunction
"}}}
function! s:suite.i_x_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #268
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #268')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #269
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #269')

  highlight link TestParen Special

  " #270
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #270')
endfunction
"}}}
function! s:suite.i_x_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #271
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'bar', 'failed at #271')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #272
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #272')

  highlight link TestParen Special

  " #273
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'bar', 'failed at #273')
endfunction
"}}}
function! s:suite.i_x_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}, {'buns': ['"', '"']}]

  """ 1
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #274
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #274')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #275
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #275')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #276
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #276')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #277
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #277')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #278
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #278')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #279
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #279')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #280
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '%s', 'failed at #280')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #281
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #281')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #282
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #282')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #283
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #283')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #284
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '%s', 'failed at #284')
endfunction
"}}}
function! s:suite.i_o_option_skip_breaking() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #285
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\nfoo\n", 'failed at #285')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'skip_break', 1)
  " #286
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "foo", 'failed at #286')
endfunction
"}}}
function! s:suite.i_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  " #287
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'b"c', 'failed at #287')

  " #288
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'aa(b', 'failed at #288')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #289
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "foo", 'failed at #289')

  " #290
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "foo''bar", 'failed at #290')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #291
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'oobarbaz', 'failed at #291')

  " #292
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bar', 'failed at #292')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #293
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #293')

  " #294
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #294')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #295
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #295')

  " #296
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #296')
endfunction
"}}}

function! s:suite.a_o_default_recipes() abort "{{{
  " #297
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(foo)', 'failed at #297')

  " #298
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '[foo]', 'failed at #298')

  " #299
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '{foo}', 'failed at #299')

  " #300
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '<foo>', 'failed at #300')

  " #301
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"foo"', 'failed at #301')

  " #302
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, "'foo'", 'failed at #302')
endfunction
"}}}
function! s:suite.a_o_nest() abort  "{{{
  " #303
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '()', 'failed at #303')

  " #304
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(a)', 'failed at #304')

  " #305
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #305')

  " #306
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #306')

  " #307
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #307')

  " #308
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #308')

  " #309
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #309')

  " #310
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #310')

  " #311
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '(cc)', 'failed at #311')

  " #312
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '(cc)', 'failed at #312')

  " #313
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '(cc)', 'failed at #313')

  " #314
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '(cc)', 'failed at #314')

  " #315
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #315')

  " #316
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #316')

  " #317
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #317')

  " #318
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #318')

  " #319
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #319')

  " #320
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #320')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #321
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #321')

  " #322
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #322')

  " #323
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #323')

  " #324
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #324')

  " #325
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #325')

  " #326
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #326')

  " #327
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #327')

  " #328
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #328')

  " #329
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #329')

  " #330
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #330')

  " #331
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #331')

  " #332
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #332')

  " #333
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #333')

  " #334
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #334')

  " #335
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #335')

  " #336
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #336')

  " #337
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #337')

  " #338
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #338')
endfunction
"}}}
function! s:suite.a_o_no_nest() abort "{{{
  " #339
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '""', 'failed at #339')

  " #340
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"a"', 'failed at #340')

  " #341
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #341')

  " #342
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '"aa"', 'failed at #342')

  " #343
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"aa"', 'failed at #343')

  " #344
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '"aa"', 'failed at #344')

  " #345
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '"bb"', 'failed at #345')

  " #346
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '"bb"', 'failed at #346')

  " #347
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '"cc"', 'failed at #347')

  " #348
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '"cc"', 'failed at #348')

  " #349
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '"cc"', 'failed at #349')

  " #350
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '"cc"', 'failed at #350')

  " #351
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '"bb"', 'failed at #351')

  " #352
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '"bb"', 'failed at #352')

  " #353
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '"aa"', 'failed at #353')

  " #354
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '"aa"', 'failed at #354')

  " #355
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '"aa"', 'failed at #355')

  " #356
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '"aa"', 'failed at #356')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #357
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"""aa"""', 'failed at #357')

  " #358
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #358')

  " #359
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #359')

  " #360
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #360')

  " #361
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #361')

  " #362
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #362')

  " #363
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #363')

  " #364
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #364')

  " #365
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '"""bb"""', 'failed at #365')

  " #366
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '"""bb"""', 'failed at #366')

  " #367
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #367')

  " #368
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #368')

  " #369
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #369')

  " #370
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #370')

  " #371
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #371')

  " #372
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #372')

  " #373
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #373')

  " #374
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #374')
endfunction
"}}}
function! s:suite.a_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #375
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #375')
endfunction
"}}}
function! s:suite.a_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #376
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #376')

  " #377
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #377')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #378
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #378')

  " #379
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '2aa3', 'failed at #379')

  " #380
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #380')

  " #381
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $yab
  call g:assert.equals(@@, '', 'failed at #381')
endfunction
"}}}
function! s:suite.a_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #382
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #382')

  " #383
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #383')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #384
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #384')

  " #385
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '888aa888', 'failed at #385')
endfunction
"}}}
function! s:suite.a_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #386
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, 'afooa', 'failed at #386')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #387
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, 'afooaa', 'failed at #387')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #388
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'''foo'''", 'failed at #388')
endfunction
"}}}
function! s:suite.a_o_option_quoteescape() abort  "{{{
  " #389
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #389')
endfunction
"}}}
function! s:suite.a_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #390
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #390')

  %delete

  " #391
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #391')

  %delete

  " #392
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #392')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #393
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #393')

  %delete

  " #394
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #394')

  %delete

  " #395
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #395')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #396
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #396')

  %delete

  " #397
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyab
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #397')

  %delete

  " #398
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #398')
endfunction
"}}}
function! s:suite.a_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #399
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #399')

  " #400
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '{foo}', 'failed at #400')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #401
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #401')

  " #402
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #402')
endfunction
"}}}
function! s:suite.a_o_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #403
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #403')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #404
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #404')

  highlight link TestParen Special

  " #405
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #405')
endfunction
"}}}
function! s:suite.a_o_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #406
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(bar)', 'failed at #406')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #407
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #407')

  highlight link TestParen Special

  " #408
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(bar)', 'failed at #408')
endfunction
"}}}
function! s:suite.a_o_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}, {'buns': ['"', '"']}]

  """ 1
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #409
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #409')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #410
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #410')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #411
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #411')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #412
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #412')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #413
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #413')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #414
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #414')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #415
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"%s"', 'failed at #415')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #416
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #416')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #417
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #417')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #418
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #418')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #419
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"%s"', 'failed at #419')
endfunction
"}}}
function! s:suite.a_o_option_synchro() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'nesting': 1}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('auto', 'synchro', 1)
  nmap sd <Plug>(operator-sandwich-delete)

  " #420
  call setline('.', '(foo)')
  normal 0sdab
  call g:assert.equals(getline('.'), 'foo', 'failed at #420')

  " #421
  call setline('.', '((foo))')
  normal 0ff2sd2ab
  call g:assert.equals(getline('.'), 'foo', 'failed at #421')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]
  let g:operator#sandwich#recipes = []

  " #422
  call setline('.', '<bar>foo</bar>')
  normal 0sdab
  call g:assert.equals(getline('.'), 'foo', 'failed at #422')

  " #423
  call setline('.', '<baz><bar>foo</bar></baz>')
  normal 0ff2sd2ab
  call g:assert.equals(getline('.'), 'foo', 'failed at #423')
endfunction
"}}}
function! s:suite.a_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(((', ')))']}, {'buns': ['(', ')']}]

  " #424
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '(b"c)', 'failed at #424')

  " #425
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '"aa(b"', 'failed at #425')

  " #426
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '(foo)', 'failed at #426')

  " #427
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '(((foo)))', 'failed at #427')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #428
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'foo'", 'failed at #428')

  " #429
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'foo''bar'", 'failed at #429')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #430
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, 'foobarbaz', 'failed at #430')

  " #431
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '^bar$', 'failed at #431')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #432
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '2foo2', 'failed at #432')

  " #433
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '1+1foo1+1', 'failed at #433')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #434
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '[foo]', 'failed at #434')

  " #435
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '{foo}', 'failed at #435')
endfunction
"}}}

function! s:suite.a_x_default_recipes() abort "{{{
  " #436
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(foo)', 'failed at #436')

  " #437
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '[foo]', 'failed at #437')

  " #438
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '{foo}', 'failed at #438')

  " #439
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '<foo>', 'failed at #439')

  " #440
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"foo"', 'failed at #440')

  " #441
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, "'foo'", 'failed at #441')
endfunction
"}}}
function! s:suite.a_x_nest() abort  "{{{
  " #442
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '()', 'failed at #442')

  " #443
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(a)', 'failed at #443')

  " #444
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #444')

  " #445
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #445')

  " #446
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #446')

  " #447
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #447')

  " #448
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #448')

  " #449
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #449')

  " #450
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #450')

  " #451
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #451')

  " #452
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #452')

  " #453
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #453')

  " #454
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #454')

  " #455
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #455')

  " #456
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #456')

  " #457
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #457')

  " #458
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #458')

  " #459
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #459')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #460
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #460')

  " #461
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #461')

  " #462
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #462')

  " #463
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #463')

  " #464
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #464')

  " #465
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #465')

  " #466
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #466')

  " #467
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #467')

  " #468
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #468')

  " #469
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #469')

  " #470
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #470')

  " #471
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #471')

  " #472
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #472')

  " #473
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #473')

  " #474
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #474')

  " #475
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #475')

  " #476
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #476')

  " #477
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #477')
endfunction
"}}}
function! s:suite.a_x_no_nest() abort "{{{
  " #478
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '""', 'failed at #478')

  " #479
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"a"', 'failed at #479')

  " #480
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #480')

  " #481
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #481')

  " #482
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #482')

  " #483
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #483')

  " #484
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #484')

  " #485
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #485')

  " #486
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #486')

  " #487
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #487')

  " #488
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #488')

  " #489
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #489')

  " #490
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #490')

  " #491
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #491')

  " #492
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #492')

  " #493
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #493')

  " #494
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #494')

  " #495
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #495')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #496
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #496')

  " #497
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #497')

  " #498
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #498')

  " #499
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #499')

  " #500
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #500')

  " #501
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #501')

  " #502
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #502')

  " #503
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #503')

  " #504
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '"""bb"""', 'failed at #504')

  " #505
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '"""bb"""', 'failed at #505')

  " #506
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #506')

  " #507
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #507')

  " #508
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #508')

  " #509
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #509')

  " #510
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #510')

  " #511
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #511')

  " #512
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #512')

  " #513
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #513')
endfunction
"}}}
function! s:suite.a_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = []

  " #514
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #514')
endfunction
"}}}
function! s:suite.a_x_selected_area_extending() abort  "{{{
  " #515
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvaby
  call g:assert.equals(@@, '{cc}', 'failed at #515')

  " #516
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvababy
  call g:assert.equals(@@, '[bb{cc}bb]', 'failed at #516')

  " #517
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvabababy
  call g:assert.equals(@@, '(aa[bb{cc}bb]aa)', 'failed at #517')
endfunction
"}}}
function! s:suite.a_x_blockwise_visual() abort  "{{{
  " #518
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>aby"
  call g:assert.equals(@@, "( \naa\n  )", 'failed at #518')

  %delete

  " #519
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #519')

  %delete

  " #520
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #520')

  %delete

  " #521
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(ccc)", 'failed at #521')

  %delete

  " #522
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joaby"
  call g:assert.equals(@@, "(aaa)\n(bb)\n(cc)", 'failed at #522')
endfunction
"}}}
function! s:suite.a_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #523
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #523')

  " #524
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2', 'failed at #524')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #525
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '1', 'failed at #525')

  " #526
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2aa3', 'failed at #526')

  " #527
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2', 'failed at #527')

  " #528
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $vaby
  call g:assert.equals(@@, '3', 'failed at #528')
endfunction
"}}}
function! s:suite.a_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #529
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #529')

  " #530
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '8', 'failed at #530')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #531
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '\', 'failed at #531')

  " #532
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '888aa888', 'failed at #532')
endfunction
"}}}
function! s:suite.a_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #533
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'afooa', 'failed at #533')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #534
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'afooaa', 'failed at #534')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #535
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'''foo'''", 'failed at #535')
endfunction
"}}}
function! s:suite.a_x_option_quoteescape() abort  "{{{
  " #536
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #536')
endfunction
"}}}
function! s:suite.a_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #537
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #537')

  %delete

  " #538
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #538')

  %delete

  " #539
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #539')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #540
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #540')

  %delete

  " #541
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #541')

  %delete

  " #542
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #542')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #543
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #543')

  %delete

  " #544
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvaby
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #544')

  %delete

  " #545
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #545')
endfunction
"}}}
function! s:suite.a_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #546
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #546')

  " #547
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{foo}', 'failed at #547')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #548
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #548')

  " #549
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{', 'failed at #549')
endfunction
"}}}
function! s:suite.a_x_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #550
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #550')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #551
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #551')

  highlight link TestParen Special

  " #552
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #552')
endfunction
"}}}
function! s:suite.a_x_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #553
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(bar)', 'failed at #553')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #554
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #554')

  highlight link TestParen Special

  " #555
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(bar)', 'failed at #555')
endfunction
"}}}
function! s:suite.a_x_option_match_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}, {'buns': ['"', '"']}]

  """ 1
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #556
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #556')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #557
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #557')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #558
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #558')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #559
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #559')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #560
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #560')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #561
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #561')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #562
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"%s"', 'failed at #562')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #563
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #563')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #564
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #564')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #565
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #565')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #566
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"%s"', 'failed at #566')
endfunction
"}}}
function! s:suite.a_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(((', ')))']}, {'buns': ['(', ')']}]

  " #567
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '(b"c)', 'failed at #567')

  " #568
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '"aa(b"', 'failed at #568')

  " #569
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(foo)', 'failed at #569')

  " #570
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(((foo)))', 'failed at #570')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #571
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'foo'", 'failed at #571')

  " #572
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'foo''bar'", 'failed at #572')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #573
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, 'foobarbaz', 'failed at #573')

  " #574
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '^bar$', 'failed at #574')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #575
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '2foo2', 'failed at #575')

  " #576
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '1+1foo1+1', 'failed at #576')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #577
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '[foo]', 'failed at #577')

  " #578
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '{foo}', 'failed at #578')
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

  " #579
  call setline('.', '"foo\""')
  normal 0dib
  call g:assert.equals(getline('.'), '""', 'failed at #579')

  " #580
  call setline('.', '(foo)')
  normal 0dib
  call g:assert.equals(getline('.'), '(foo)', 'failed at #580')

  " #581
  call setline('.', '[foo]')
  normal 0dib
  call g:assert.equals(getline('.'), '[]', 'failed at #581')

  " #582
  call setline('.', '"foo\""')
  normal 0diib
  call g:assert.equals(getline('.'), '"""', 'failed at #582')

  " #583
  call setline('.', '(foo)')
  normal 0diib
  call g:assert.equals(getline('.'), '()', 'failed at #583')

  " #584
  call setline('.', '[foo]')
  normal 0diib
  call g:assert.equals(getline('.'), '[foo]', 'failed at #584')
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

  " #585
  call setline('.', '"foo\""')
  normal 0dab
  call g:assert.equals(getline('.'), '', 'failed at #585')

  " #586
  call setline('.', '(foo)')
  normal 0dab
  call g:assert.equals(getline('.'), '(foo)', 'failed at #586')

  " #587
  call setline('.', '[foo]')
  normal 0dab
  call g:assert.equals(getline('.'), '', 'failed at #587')

  " #588
  call setline('.', '"foo\""')
  normal 0daab
  call g:assert.equals(getline('.'), '"', 'failed at #588')

  " #589
  call setline('.', '(foo)')
  normal 0daab
  call g:assert.equals(getline('.'), '', 'failed at #589')

  " #590
  call setline('.', '[foo]')
  normal 0daab
  call g:assert.equals(getline('.'), '[foo]', 'failed at #590')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
