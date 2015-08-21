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
function! s:suite.i_o_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('auto', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #144
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aaa', 'failed at #144')

  %delete

  """ funcref
  call textobj#sandwich#set('auto', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #145
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aaa', 'failed at #145')
endfunction
"}}}
function! s:suite.i_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  " #146
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'b"c', 'failed at #146')

  " #147
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'aa(b', 'failed at #147')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #148
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, "foo", 'failed at #148')

  " #149
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, "foo''bar", 'failed at #149')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #150
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'oobarbaz', 'failed at #150')

  " #151
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'bar', 'failed at #151')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #152
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #152')

  " #153
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #153')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #154
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #154')

  " #155
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #155')
endfunction
"}}}

function! s:suite.i_x_default_recipes() abort "{{{
  " #156
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #156')

  " #157
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #157')

  " #158
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #158')

  " #159
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #159')

  " #160
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #160')

  " #161
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #161')
endfunction
"}}}
function! s:suite.i_x_nest() abort  "{{{
  " #162
  call setline('.', '()')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #162')

  " #163
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'a', 'failed at #163')

  " #164
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #164')

  " #165
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #165')

  " #166
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #166')

  " #167
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #167')

  " #168
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #168')

  " #169
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #169')

  " #170
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'cc', 'failed at #170')

  " #171
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'cc', 'failed at #171')

  " #172
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'cc', 'failed at #172')

  " #173
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'cc', 'failed at #173')

  " #174
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #174')

  " #175
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #175')

  " #176
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #176')

  " #177
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #177')

  " #178
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #178')

  " #179
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #179')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #180
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #180')

  " #181
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #181')

  " #182
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #182')

  " #183
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #183')

  " #184
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #184')

  " #185
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb', 'failed at #185')

  " #186
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'bb', 'failed at #186')

  " #187
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'bb', 'failed at #187')

  " #188
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'bb', 'failed at #188')

  " #189
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'bb', 'failed at #189')

  " #190
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb', 'failed at #190')

  " #191
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb', 'failed at #191')

  " #192
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'bb', 'failed at #192')

  " #193
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #193')

  " #194
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #194')

  " #195
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #195')

  " #196
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #196')

  " #197
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #197')
endfunction
"}}}
function! s:suite.i_x_no_nest() abort "{{{
  " #198
  call setline('.', '""')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '"', 'failed at #198')

  " #199
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'a', 'failed at #199')

  " #200
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #200')

  " #201
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa', 'failed at #201')

  " #202
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa', 'failed at #202')

  " #203
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa', 'failed at #203')

  " #204
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'bb', 'failed at #204')

  " #205
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb', 'failed at #205')

  " #206
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'cc', 'failed at #206')

  " #207
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'cc', 'failed at #207')

  " #208
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'cc', 'failed at #208')

  " #209
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'cc', 'failed at #209')

  " #210
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb', 'failed at #210')

  " #211
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb', 'failed at #211')

  " #212
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'aa', 'failed at #212')

  " #213
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa', 'failed at #213')

  " #214
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa', 'failed at #214')

  " #215
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa', 'failed at #215')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #216
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #216')

  " #217
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa', 'failed at #217')

  " #218
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa', 'failed at #218')

  " #219
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa', 'failed at #219')

  " #220
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'aa', 'failed at #220')

  " #221
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'aa', 'failed at #221')

  " #222
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'aa', 'failed at #222')

  " #223
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'aa', 'failed at #223')

  " #224
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'bb', 'failed at #224')

  " #225
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'bb', 'failed at #225')

  " #226
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'cc', 'failed at #226')

  " #227
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'cc', 'failed at #227')

  " #228
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'cc', 'failed at #228')

  " #229
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'cc', 'failed at #229')

  " #230
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'cc', 'failed at #230')

  " #231
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'cc', 'failed at #231')

  " #232
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lviby
  call g:assert.equals(@@, 'cc', 'failed at #232')

  " #233
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lviby
  call g:assert.equals(@@, 'cc', 'failed at #233')
endfunction
"}}}
function! s:suite.i_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #234
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bb', 'failed at #234')
endfunction
"}}}
function! s:suite.i_x_selected_area_extending() abort  "{{{
  " #235
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcviby
  call g:assert.equals(@@, 'cc', 'failed at #235')

  " #236
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvibiby
  call g:assert.equals(@@, 'bb{cc}bb', 'failed at #236')

  " #237
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvibibiby
  call g:assert.equals(@@, 'aa[bb{cc}bb]aa', 'failed at #237')
endfunction
"}}}
function! s:suite.i_x_blockwise_visual() abort  "{{{
  " #238
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>iby"
  call g:assert.equals(@@, " \na\n ", 'failed at #238')

  %delete

  " #239
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jiby"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #239')

  %delete

  " #240
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joiby"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #240')

  %delete

  " #241
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jiby"
  call g:assert.equals(@@, "aa)\nbb)\nccc", 'failed at #241')

  %delete

  " #242
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joiby"
  call g:assert.equals(@@, "aaa\nbb)\ncc)", 'failed at #242')
endfunction
"}}}
function! s:suite.i_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #243
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #243')

  " #244
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '2', 'failed at #244')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #245
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '1', 'failed at #245')

  " #246
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #246')

  " #247
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '2', 'failed at #247')

  " #248
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $viby
  call g:assert.equals(@@, '3', 'failed at #248')
endfunction
"}}}
function! s:suite.i_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #249
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #249')

  " #250
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '8', 'failed at #250')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #251
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '\', 'failed at #251')

  " #252
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #252')
endfunction
"}}}
function! s:suite.i_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #253
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #253')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #254
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'fooa', 'failed at #254')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #255
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "''foo''", 'failed at #255')
endfunction
"}}}
function! s:suite.i_x_option_quoteescape() abort  "{{{
  " #256
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa\"bb', 'failed at #256')
endfunction
"}}}
function! s:suite.i_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #257
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #257')

  %delete

  " #258
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\naa\n", 'failed at #258')

  %delete

  " #259
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #259')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #260
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #260')

  %delete

  " #261
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #261')

  %delete

  " #262
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #262')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #263
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #263')

  %delete

  " #264
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjviby
  call g:assert.equals(@@, "\naa\n", 'failed at #264')

  %delete

  " #265
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #265')
endfunction
"}}}
function! s:suite.i_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #266
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #266')

  " #267
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #267')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #268
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #268')

  " #269
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '{', 'failed at #269')

endfunction
"}}}
function! s:suite.i_x_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #270
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #270')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #271
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #271')

  highlight link TestParen Special

  " #272
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #272')
endfunction
"}}}
function! s:suite.i_x_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #273
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'bar', 'failed at #273')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #274
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #274')

  highlight link TestParen Special

  " #275
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'bar', 'failed at #275')
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

  " #276
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #276')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #277
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #277')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #278
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #278')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #279
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #279')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #280
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #280')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #281
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #281')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #282
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '%s', 'failed at #282')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #283
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #283')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #284
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #284')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #285
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #285')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #286
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '%s', 'failed at #286')
endfunction
"}}}
function! s:suite.i_x_option_skip_breaking() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #287
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\nfoo\n", 'failed at #287')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'skip_break', 1)
  " #288
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "foo", 'failed at #288')
endfunction
"}}}
function! s:suite.i_x_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('auto', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #289
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aaa', 'failed at #289')

  %delete

  """ funcref
  call textobj#sandwich#set('auto', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #290
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aaa', 'failed at #290')
endfunction
"}}}
function! s:suite.i_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  " #291
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'b"c', 'failed at #291')

  " #292
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'aa(b', 'failed at #292')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #293
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "foo", 'failed at #293')

  " #294
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "foo''bar", 'failed at #294')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #295
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'oobarbaz', 'failed at #295')

  " #296
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bar', 'failed at #296')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #297
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #297')

  " #298
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #298')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #299
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #299')

  " #300
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #300')
endfunction
"}}}

function! s:suite.a_o_default_recipes() abort "{{{
  " #301
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(foo)', 'failed at #301')

  " #302
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '[foo]', 'failed at #302')

  " #303
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '{foo}', 'failed at #303')

  " #304
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '<foo>', 'failed at #304')

  " #305
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"foo"', 'failed at #305')

  " #306
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, "'foo'", 'failed at #306')
endfunction
"}}}
function! s:suite.a_o_nest() abort  "{{{
  " #307
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '()', 'failed at #307')

  " #308
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(a)', 'failed at #308')

  " #309
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #309')

  " #310
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #310')

  " #311
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #311')

  " #312
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #312')

  " #313
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #313')

  " #314
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #314')

  " #315
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '(cc)', 'failed at #315')

  " #316
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '(cc)', 'failed at #316')

  " #317
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '(cc)', 'failed at #317')

  " #318
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '(cc)', 'failed at #318')

  " #319
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #319')

  " #320
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #320')

  " #321
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #321')

  " #322
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #322')

  " #323
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #323')

  " #324
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #324')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #325
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #325')

  " #326
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #326')

  " #327
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #327')

  " #328
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #328')

  " #329
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #329')

  " #330
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #330')

  " #331
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #331')

  " #332
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #332')

  " #333
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #333')

  " #334
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #334')

  " #335
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #335')

  " #336
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #336')

  " #337
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #337')

  " #338
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #338')

  " #339
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #339')

  " #340
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #340')

  " #341
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #341')

  " #342
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #342')
endfunction
"}}}
function! s:suite.a_o_no_nest() abort "{{{
  " #343
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '""', 'failed at #343')

  " #344
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"a"', 'failed at #344')

  " #345
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #345')

  " #346
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '"aa"', 'failed at #346')

  " #347
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"aa"', 'failed at #347')

  " #348
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '"aa"', 'failed at #348')

  " #349
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '"bb"', 'failed at #349')

  " #350
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '"bb"', 'failed at #350')

  " #351
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '"cc"', 'failed at #351')

  " #352
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '"cc"', 'failed at #352')

  " #353
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '"cc"', 'failed at #353')

  " #354
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '"cc"', 'failed at #354')

  " #355
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '"bb"', 'failed at #355')

  " #356
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '"bb"', 'failed at #356')

  " #357
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '"aa"', 'failed at #357')

  " #358
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '"aa"', 'failed at #358')

  " #359
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '"aa"', 'failed at #359')

  " #360
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '"aa"', 'failed at #360')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #361
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"""aa"""', 'failed at #361')

  " #362
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #362')

  " #363
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #363')

  " #364
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #364')

  " #365
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #365')

  " #366
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #366')

  " #367
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #367')

  " #368
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #368')

  " #369
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '"""bb"""', 'failed at #369')

  " #370
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '"""bb"""', 'failed at #370')

  " #371
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #371')

  " #372
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #372')

  " #373
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #373')

  " #374
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #374')

  " #375
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #375')

  " #376
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #376')

  " #377
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #377')

  " #378
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #378')
endfunction
"}}}
function! s:suite.a_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #379
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #379')
endfunction
"}}}
function! s:suite.a_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #380
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #380')

  " #381
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #381')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #382
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #382')

  " #383
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '2aa3', 'failed at #383')

  " #384
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #384')

  " #385
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $yab
  call g:assert.equals(@@, '', 'failed at #385')
endfunction
"}}}
function! s:suite.a_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #386
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #386')

  " #387
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #387')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #388
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #388')

  " #389
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '888aa888', 'failed at #389')
endfunction
"}}}
function! s:suite.a_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #390
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, 'afooa', 'failed at #390')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #391
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, 'afooaa', 'failed at #391')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #392
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'''foo'''", 'failed at #392')
endfunction
"}}}
function! s:suite.a_o_option_quoteescape() abort  "{{{
  " #393
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #393')
endfunction
"}}}
function! s:suite.a_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #394
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #394')

  %delete

  " #395
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #395')

  %delete

  " #396
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #396')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #397
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #397')

  %delete

  " #398
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #398')

  %delete

  " #399
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #399')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #400
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #400')

  %delete

  " #401
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyab
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #401')

  %delete

  " #402
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #402')
endfunction
"}}}
function! s:suite.a_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #403
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #403')

  " #404
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '{foo}', 'failed at #404')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #405
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #405')

  " #406
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #406')
endfunction
"}}}
function! s:suite.a_o_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #407
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #407')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #408
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #408')

  highlight link TestParen Special

  " #409
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #409')
endfunction
"}}}
function! s:suite.a_o_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #410
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(bar)', 'failed at #410')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #411
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #411')

  highlight link TestParen Special

  " #412
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(bar)', 'failed at #412')
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

  " #413
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #413')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #414
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #414')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #415
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #415')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #416
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #416')

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

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #420
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #420')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #421
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #421')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #422
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #422')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #423
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"%s"', 'failed at #423')
endfunction
"}}}
function! s:suite.a_o_option_synchro() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'nesting': 1}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('auto', 'synchro', 1)
  nmap sd <Plug>(operator-sandwich-delete)

  " #424
  call setline('.', '(foo)')
  normal 0sdab
  call g:assert.equals(getline('.'), 'foo', 'failed at #424')

  " #425
  call setline('.', '((foo))')
  normal 0ff2sd2ab
  call g:assert.equals(getline('.'), 'foo', 'failed at #425')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]
  let g:operator#sandwich#recipes = []

  " #426
  call setline('.', '<bar>foo</bar>')
  normal 0sdab
  call g:assert.equals(getline('.'), 'foo', 'failed at #426')

  " #427
  call setline('.', '<baz><bar>foo</bar></baz>')
  normal 0ff2sd2ab
  call g:assert.equals(getline('.'), 'foo', 'failed at #427')
endfunction
"}}}
function! s:suite.a_o_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('auto', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #428
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, 'aaaaa', 'failed at #428')

  %delete

  """ funcref
  call textobj#sandwich#set('auto', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #429
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, 'aaaaa', 'failed at #429')
endfunction
"}}}
function! s:suite.a_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(((', ')))']}, {'buns': ['(', ')']}]

  " #430
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '(b"c)', 'failed at #430')

  " #431
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '"aa(b"', 'failed at #431')

  " #432
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '(foo)', 'failed at #432')

  " #433
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '(((foo)))', 'failed at #433')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #434
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'foo'", 'failed at #434')

  " #435
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'foo''bar'", 'failed at #435')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #436
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, 'foobarbaz', 'failed at #436')

  " #437
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '^bar$', 'failed at #437')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #438
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '2foo2', 'failed at #438')

  " #439
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '1+1foo1+1', 'failed at #439')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #440
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '[foo]', 'failed at #440')

  " #441
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '{foo}', 'failed at #441')
endfunction
"}}}

function! s:suite.a_x_default_recipes() abort "{{{
  " #442
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(foo)', 'failed at #442')

  " #443
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '[foo]', 'failed at #443')

  " #444
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '{foo}', 'failed at #444')

  " #445
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '<foo>', 'failed at #445')

  " #446
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"foo"', 'failed at #446')

  " #447
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, "'foo'", 'failed at #447')
endfunction
"}}}
function! s:suite.a_x_nest() abort  "{{{
  " #448
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '()', 'failed at #448')

  " #449
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(a)', 'failed at #449')

  " #450
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #450')

  " #451
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #451')

  " #452
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #452')

  " #453
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #453')

  " #454
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #454')

  " #455
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #455')

  " #456
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #456')

  " #457
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #457')

  " #458
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #458')

  " #459
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #459')

  " #460
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #460')

  " #461
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #461')

  " #462
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #462')

  " #463
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #463')

  " #464
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #464')

  " #465
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #465')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #466
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #466')

  " #467
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #467')

  " #468
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #468')

  " #469
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #469')

  " #470
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #470')

  " #471
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #471')

  " #472
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #472')

  " #473
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #473')

  " #474
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #474')

  " #475
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #475')

  " #476
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #476')

  " #477
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #477')

  " #478
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #478')

  " #479
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #479')

  " #480
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #480')

  " #481
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #481')

  " #482
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #482')

  " #483
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #483')
endfunction
"}}}
function! s:suite.a_x_no_nest() abort "{{{
  " #484
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '""', 'failed at #484')

  " #485
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"a"', 'failed at #485')

  " #486
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #486')

  " #487
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #487')

  " #488
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #488')

  " #489
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #489')

  " #490
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #490')

  " #491
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #491')

  " #492
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #492')

  " #493
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #493')

  " #494
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #494')

  " #495
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #495')

  " #496
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #496')

  " #497
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #497')

  " #498
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #498')

  " #499
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #499')

  " #500
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #500')

  " #501
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #501')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #502
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #502')

  " #503
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #503')

  " #504
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #504')

  " #505
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #505')

  " #506
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #506')

  " #507
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #507')

  " #508
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #508')

  " #509
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #509')

  " #510
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '"""bb"""', 'failed at #510')

  " #511
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '"""bb"""', 'failed at #511')

  " #512
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #512')

  " #513
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #513')

  " #514
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #514')

  " #515
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #515')

  " #516
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #516')

  " #517
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #517')

  " #518
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #518')

  " #519
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #519')
endfunction
"}}}
function! s:suite.a_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = []

  " #520
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #520')
endfunction
"}}}
function! s:suite.a_x_selected_area_extending() abort  "{{{
  " #521
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvaby
  call g:assert.equals(@@, '{cc}', 'failed at #521')

  " #522
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvababy
  call g:assert.equals(@@, '[bb{cc}bb]', 'failed at #522')

  " #523
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvabababy
  call g:assert.equals(@@, '(aa[bb{cc}bb]aa)', 'failed at #523')
endfunction
"}}}
function! s:suite.a_x_blockwise_visual() abort  "{{{
  " #524
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>aby"
  call g:assert.equals(@@, "( \naa\n  )", 'failed at #524')

  %delete

  " #525
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #525')

  %delete

  " #526
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #526')

  %delete

  " #527
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(ccc)", 'failed at #527')

  %delete

  " #528
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joaby"
  call g:assert.equals(@@, "(aaa)\n(bb)\n(cc)", 'failed at #528')
endfunction
"}}}
function! s:suite.a_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #529
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #529')

  " #530
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2', 'failed at #530')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #531
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '1', 'failed at #531')

  " #532
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2aa3', 'failed at #532')

  " #533
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2', 'failed at #533')

  " #534
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $vaby
  call g:assert.equals(@@, '3', 'failed at #534')
endfunction
"}}}
function! s:suite.a_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #535
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #535')

  " #536
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '8', 'failed at #536')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #537
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '\', 'failed at #537')

  " #538
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '888aa888', 'failed at #538')
endfunction
"}}}
function! s:suite.a_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #539
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'afooa', 'failed at #539')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #540
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'afooaa', 'failed at #540')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #541
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'''foo'''", 'failed at #541')
endfunction
"}}}
function! s:suite.a_x_option_quoteescape() abort  "{{{
  " #542
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #542')
endfunction
"}}}
function! s:suite.a_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #543
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #543')

  %delete

  " #544
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #544')

  %delete

  " #545
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #545')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #546
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #546')

  %delete

  " #547
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #547')

  %delete

  " #548
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #548')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #549
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #549')

  %delete

  " #550
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvaby
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #550')

  %delete

  " #551
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #551')
endfunction
"}}}
function! s:suite.a_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #552
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #552')

  " #553
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{foo}', 'failed at #553')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #554
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #554')

  " #555
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{', 'failed at #555')
endfunction
"}}}
function! s:suite.a_x_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #556
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #556')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #557
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #557')

  highlight link TestParen Special

  " #558
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #558')
endfunction
"}}}
function! s:suite.a_x_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #559
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(bar)', 'failed at #559')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #560
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #560')

  highlight link TestParen Special

  " #561
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(bar)', 'failed at #561')
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

  " #562
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #562')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #563
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #563')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #564
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #564')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #565
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #565')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #566
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #566')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #567
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #567')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #568
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"%s"', 'failed at #568')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #569
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #569')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #570
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #570')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #571
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #571')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #572
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"%s"', 'failed at #572')
endfunction
"}}}
function! s:suite.a_x_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('auto', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #573
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, 'aaaaa', 'failed at #573')

  %delete

  """ funcref
  call textobj#sandwich#set('auto', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #574
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, 'aaaaa', 'failed at #574')
endfunction
"}}}
function! s:suite.a_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(((', ')))']}, {'buns': ['(', ')']}]

  " #575
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '(b"c)', 'failed at #575')

  " #576
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '"aa(b"', 'failed at #576')

  " #577
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(foo)', 'failed at #577')

  " #578
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(((foo)))', 'failed at #578')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #579
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'foo'", 'failed at #579')

  " #580
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'foo''bar'", 'failed at #580')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #581
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, 'foobarbaz', 'failed at #581')

  " #582
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '^bar$', 'failed at #582')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #583
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '2foo2', 'failed at #583')

  " #584
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '1+1foo1+1', 'failed at #584')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #585
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '[foo]', 'failed at #585')

  " #586
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '{foo}', 'failed at #586')
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

  " #587
  call setline('.', '"foo\""')
  normal 0dib
  call g:assert.equals(getline('.'), '""', 'failed at #587')

  " #588
  call setline('.', '(foo)')
  normal 0dib
  call g:assert.equals(getline('.'), '(foo)', 'failed at #588')

  " #589
  call setline('.', '[foo]')
  normal 0dib
  call g:assert.equals(getline('.'), '[]', 'failed at #589')

  " #590
  call setline('.', '"foo\""')
  normal 0diib
  call g:assert.equals(getline('.'), '"""', 'failed at #590')

  " #591
  call setline('.', '(foo)')
  normal 0diib
  call g:assert.equals(getline('.'), '()', 'failed at #591')

  " #592
  call setline('.', '[foo]')
  normal 0diib
  call g:assert.equals(getline('.'), '[foo]', 'failed at #592')
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

  " #593
  call setline('.', '"foo\""')
  normal 0dab
  call g:assert.equals(getline('.'), '', 'failed at #593')

  " #594
  call setline('.', '(foo)')
  normal 0dab
  call g:assert.equals(getline('.'), '(foo)', 'failed at #594')

  " #595
  call setline('.', '[foo]')
  normal 0dab
  call g:assert.equals(getline('.'), '', 'failed at #595')

  " #596
  call setline('.', '"foo\""')
  normal 0daab
  call g:assert.equals(getline('.'), '"', 'failed at #596')

  " #597
  call setline('.', '(foo)')
  normal 0daab
  call g:assert.equals(getline('.'), '', 'failed at #597')

  " #598
  call setline('.', '[foo]')
  normal 0daab
  call g:assert.equals(getline('.'), '[foo]', 'failed at #598')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
