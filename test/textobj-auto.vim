scriptencoding utf-8

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

  " #7
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '()', 'failed at #7')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['query']},
        \ ]

  " #8
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '()', 'failed at #8')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['auto']},
        \ ]

  " #9
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #9')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['textobj']},
        \ ]

  " #10
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #10')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'kind': ['all']},
        \ ]

  " #11
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #11')
endfunction
"}}}
function! s:suite.filter_mode() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']']},
        \ ]

  " #12
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #12')

  " #13
  call setline('.', '([foo])')
  normal 03lvibd
  call g:assert.equals(getline('.'), '([])', 'failed at #13')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['o']},
        \ ]

  " #14
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '([])', 'failed at #14')

  " #15
  call setline('.', '([foo])')
  normal 03lvibd
  call g:assert.equals(getline('.'), '()', 'failed at #15')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['(', ')']},
        \   {'buns': ['[', ']'], 'mode': ['x']},
        \ ]

  " #16
  call setline('.', '([foo])')
  normal 03ldib
  call g:assert.equals(getline('.'), '()', 'failed at #16')

  " #17
  call setline('.', '([foo])')
  normal 03lvibd
  call g:assert.equals(getline('.'), '([])', 'failed at #17')
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

  " #18
  call setline('.', '(foo)')
  normal 0dib
  call g:assert.equals(getline('.'), '()', 'failed at #18')

  " #19
  call setline('.', '[foo]')
  normal 0dib
  call g:assert.equals(getline('.'), '[]', 'failed at #19')

  " #20
  call setline('.', '{foo}')
  normal 0dib
  call g:assert.equals(getline('.'), '{foo}', 'failed at #20')
endfunction
"}}}

function! s:suite.i_o_default_recipes() abort "{{{
  " #21
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #21')

  " #22
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #22')

  " #23
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #23')

  " #24
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #24')

  " #25
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #25')

  " #26
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'foo', 'failed at #26')
endfunction
"}}}
function! s:suite.i_o_nest() abort  "{{{
  " #27
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #27')

  " #28
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'a', 'failed at #28')

  " #29
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #29')

  " #30
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #30')

  " #31
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #31')

  " #32
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #32')

  " #33
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #33')

  " #34
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #34')

  " #35
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'cc', 'failed at #35')

  " #36
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'cc', 'failed at #36')

  " #37
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'cc', 'failed at #37')

  " #38
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'cc', 'failed at #38')

  " #39
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #39')

  " #40
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #40')

  " #41
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #41')

  " #42
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #42')

  " #43
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #43')

  " #44
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #44')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #45
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #45')

  " #46
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #46')

  " #47
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #47')

  " #48
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #48')

  " #49
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #49')

  " #50
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'bb', 'failed at #50')

  " #51
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'bb', 'failed at #51')

  " #52
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'bb', 'failed at #52')

  " #53
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'bb', 'failed at #53')

  " #54
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'bb', 'failed at #54')

  " #55
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'bb', 'failed at #55')

  " #56
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'bb', 'failed at #56')

  " #57
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'bb', 'failed at #57')

  " #58
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #58')

  " #59
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #59')

  " #60
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #60')

  " #61
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #61')

  " #62
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #62')
endfunction
"}}}
function! s:suite.i_o_no_nest() abort "{{{
  " #63
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #63')

  " #64
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'a', 'failed at #64')

  " #65
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #65')

  " #66
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa', 'failed at #66')

  " #67
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa', 'failed at #67')

  " #68
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'aa', 'failed at #68')

  " #69
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'bb', 'failed at #69')

  " #70
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'bb', 'failed at #70')

  " #71
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'cc', 'failed at #71')

  " #72
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'cc', 'failed at #72')

  " #73
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'cc', 'failed at #73')

  " #74
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'cc', 'failed at #74')

  " #75
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'bb', 'failed at #75')

  " #76
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'bb', 'failed at #76')

  " #77
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'aa', 'failed at #77')

  " #78
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'aa', 'failed at #78')

  " #79
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'aa', 'failed at #79')

  " #80
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'aa', 'failed at #80')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #81
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #81')

  " #82
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa', 'failed at #82')

  " #83
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa', 'failed at #83')

  " #84
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'aa', 'failed at #84')

  " #85
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'aa', 'failed at #85')

  " #86
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'aa', 'failed at #86')

  " #87
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'aa', 'failed at #87')

  " #88
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'aa', 'failed at #88')

  " #89
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'bb', 'failed at #89')

  " #90
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'bb', 'failed at #90')

  " #91
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'cc', 'failed at #91')

  " #92
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'cc', 'failed at #92')

  " #93
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'cc', 'failed at #93')

  " #94
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'cc', 'failed at #94')

  " #95
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'cc', 'failed at #95')

  " #96
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'cc', 'failed at #96')

  " #97
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyib
  call g:assert.equals(@@, 'cc', 'failed at #97')

  " #98
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyib
  call g:assert.equals(@@, 'cc', 'failed at #98')
endfunction
"}}}
function! s:suite.i_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #99
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'bb', 'failed at #99')
endfunction
"}}}
function! s:suite.i_o_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #100
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'bb', 'failed at #100')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #101
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'bb', 'failed at #101')
endfunction
"}}}
function! s:suite.i_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #102
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #102')

  " #103
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #103')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #104
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #104')

  " #105
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #105')

  " #106
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #106')

  " #107
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $yib
  call g:assert.equals(@@, '', 'failed at #107')

  " #108
  let g:textobj#sandwich#recipes = [{'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']}]
  call setline('.', 'headfootail')
  let @@ = 'fail'
  normal $yib
  call g:assert.equals(@@, 'foo', 'failed at #108')
endfunction
"}}}
function! s:suite.i_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #109
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #109')

  " #110
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #110')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #111
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #111')

  " #112
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #112')
endfunction
"}}}
function! s:suite.i_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #113
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #113')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #114
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'fooa', 'failed at #114')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #115
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, "''foo''", 'failed at #115')
endfunction
"}}}
function! s:suite.i_o_option_quoteescape() abort  "{{{
  " #116
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa\"bb', 'failed at #116')
endfunction
"}}}
function! s:suite.i_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #117
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #117')

  %delete

  " #118
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\naa\n", 'failed at #118')

  %delete

  " #119
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #119')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #120
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #120')

  %delete

  " #121
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #121')

  %delete

  " #122
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #122')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #123
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #123')

  %delete

  " #124
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyib
  call g:assert.equals(@@, "\naa\n", 'failed at #124')

  %delete

  " #125
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #125')
endfunction
"}}}
function! s:suite.i_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #126
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #126')

  " #127
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #127')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #128
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #128')

  " #129
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #129')
endfunction
"}}}
function! s:suite.i_o_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #130
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #130')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #131
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #131')

  highlight link TestParen Special

  " #132
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #132')
endfunction
"}}}
function! s:suite.i_o_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #133
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'bar', 'failed at #133')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #134
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #134')

  highlight link TestParen Special

  " #135
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'bar', 'failed at #135')
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

  " #136
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #136')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #137
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #137')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #138
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #138')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #139
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #139')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #140
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #140')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #141
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #141')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #142
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '%s', 'failed at #142')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #143
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #143')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #144
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #144')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #145
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #145')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #146
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '%s', 'failed at #146')
endfunction
"}}}
function! s:suite.i_o_option_skip_break() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #147
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\nfoo\n", 'failed at #147')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'skip_break', 1)
  " #148
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "foo", 'failed at #148')

  %delete

  " #149
  call append(0, ['    (', '        foo', '    )'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "foo", 'failed at #149')

  %delete

  " #150
  " do not skip when any line breaking is not included.
  call setline('.', '(  foo  )')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, "  foo  ", 'failed at #150')
endfunction
"}}}
function! s:suite.i_o_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('auto', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #151
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aaa', 'failed at #151')

  %delete

  """ funcref
  call textobj#sandwich#set('auto', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #152
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aaa', 'failed at #152')
endfunction
"}}}
function! s:suite.i_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  " #153
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'b"c', 'failed at #153')

  " #154
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'aa(b', 'failed at #154')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #155
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, "foo", 'failed at #155')

  " #156
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, "foo''bar", 'failed at #156')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #157
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'oobarbaz', 'failed at #157')

  " #158
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'bar', 'failed at #158')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #159
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #159')

  " #160
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #160')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #161
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #161')

  " #162
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #162')
endfunction
"}}}

function! s:suite.i_x_default_recipes() abort "{{{
  " #163
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #163')

  " #164
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #164')

  " #165
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #165')

  " #166
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #166')

  " #167
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #167')

  " #168
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #168')
endfunction
"}}}
function! s:suite.i_x_nest() abort  "{{{
  " #169
  call setline('.', '()')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #169')

  " #170
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'a', 'failed at #170')

  " #171
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #171')

  " #172
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #172')

  " #173
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #173')

  " #174
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #174')

  " #175
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #175')

  " #176
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #176')

  " #177
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'cc', 'failed at #177')

  " #178
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'cc', 'failed at #178')

  " #179
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'cc', 'failed at #179')

  " #180
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'cc', 'failed at #180')

  " #181
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #181')

  " #182
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #182')

  " #183
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #183')

  " #184
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #184')

  " #185
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #185')

  " #186
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #186')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #187
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #187')

  " #188
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #188')

  " #189
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #189')

  " #190
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #190')

  " #191
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #191')

  " #192
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb', 'failed at #192')

  " #193
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'bb', 'failed at #193')

  " #194
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'bb', 'failed at #194')

  " #195
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'bb', 'failed at #195')

  " #196
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'bb', 'failed at #196')

  " #197
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb', 'failed at #197')

  " #198
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb', 'failed at #198')

  " #199
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'bb', 'failed at #199')

  " #200
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #200')

  " #201
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #201')

  " #202
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #202')

  " #203
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #203')

  " #204
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #204')
endfunction
"}}}
function! s:suite.i_x_no_nest() abort "{{{
  " #205
  call setline('.', '""')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '"', 'failed at #205')

  " #206
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'a', 'failed at #206')

  " #207
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #207')

  " #208
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa', 'failed at #208')

  " #209
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa', 'failed at #209')

  " #210
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa', 'failed at #210')

  " #211
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'bb', 'failed at #211')

  " #212
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb', 'failed at #212')

  " #213
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'cc', 'failed at #213')

  " #214
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'cc', 'failed at #214')

  " #215
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'cc', 'failed at #215')

  " #216
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'cc', 'failed at #216')

  " #217
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb', 'failed at #217')

  " #218
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb', 'failed at #218')

  " #219
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'aa', 'failed at #219')

  " #220
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa', 'failed at #220')

  " #221
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa', 'failed at #221')

  " #222
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa', 'failed at #222')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #223
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #223')

  " #224
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa', 'failed at #224')

  " #225
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa', 'failed at #225')

  " #226
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa', 'failed at #226')

  " #227
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'aa', 'failed at #227')

  " #228
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'aa', 'failed at #228')

  " #229
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'aa', 'failed at #229')

  " #230
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'aa', 'failed at #230')

  " #231
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'bb', 'failed at #231')

  " #232
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'bb', 'failed at #232')

  " #233
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'cc', 'failed at #233')

  " #234
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'cc', 'failed at #234')

  " #235
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'cc', 'failed at #235')

  " #236
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'cc', 'failed at #236')

  " #237
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'cc', 'failed at #237')

  " #238
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'cc', 'failed at #238')

  " #239
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lviby
  call g:assert.equals(@@, 'cc', 'failed at #239')

  " #240
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lviby
  call g:assert.equals(@@, 'cc', 'failed at #240')
endfunction
"}}}
function! s:suite.i_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #241
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bb', 'failed at #241')
endfunction
"}}}
function! s:suite.i_x_selected_area_extending() abort  "{{{
  " #242
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcviby
  call g:assert.equals(@@, 'cc', 'failed at #242')

  " #243
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvibiby
  call g:assert.equals(@@, 'bb{cc}bb', 'failed at #243')

  " #244
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvibibiby
  call g:assert.equals(@@, 'aa[bb{cc}bb]aa', 'failed at #244')

  %delete

  " #245
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['if', 'endif'], 'nesting': 1},
        \   {'buns': ['if', 'else'], 'nesting': 1},
        \   {'buns': ['else', 'endif'], 'nesting': 1},
        \ ]
  call append(0, ['if', '  foo', '  foo', 'else', '  bar', '  bar', 'endif'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\n  foo\n  foo\n", 'failed at #245')

  " #246
  let @@ = 'fail'
  normal ggvibiby
  call g:assert.equals(@@, "\n  foo\n  foo\nelse\n  bar\n  bar\n", 'failed at #246')

  " #247
  let @@ = 'fail'
  normal 5Gviby
  call g:assert.equals(@@, "\n  bar\n  bar\n", 'failed at #247')

  " #248
  let @@ = 'fail'
  normal 5Gvibiby
  call g:assert.equals(@@, "\n  foo\n  foo\nelse\n  bar\n  bar\n", 'failed at #248')
endfunction
"}}}
function! s:suite.i_x_blockwise_visual() abort  "{{{
  " #249
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>iby"
  call g:assert.equals(@@, " \na\n ", 'failed at #249')

  %delete

  " #250
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jiby"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #250')

  %delete

  " #251
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joiby"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #251')

  %delete

  " #252
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jiby"
  call g:assert.equals(@@, "aa)\nbb)\nccc", 'failed at #252')

  %delete

  " #253
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joiby"
  call g:assert.equals(@@, "aaa\nbb)\ncc)", 'failed at #253')
endfunction
"}}}
function! s:suite.i_x_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #254
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bb', 'failed at #254')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #255
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bb', 'failed at #255')
endfunction
"}}}
function! s:suite.i_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #256
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #256')

  " #257
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '2', 'failed at #257')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #258
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '1', 'failed at #258')

  " #259
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #259')

  " #260
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '2', 'failed at #260')

  " #261
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $viby
  call g:assert.equals(@@, '3', 'failed at #261')

  " #262
  let g:textobj#sandwich#recipes = [{'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']}]
  call setline('.', 'headfootail')
  let @@ = 'fail'
  normal $viby
  call g:assert.equals(@@, 'foo', 'failed at #262')
endfunction
"}}}
function! s:suite.i_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #263
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #263')

  " #264
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '8', 'failed at #264')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #265
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '\', 'failed at #265')

  " #266
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #266')
endfunction
"}}}
function! s:suite.i_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #267
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #267')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #268
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'fooa', 'failed at #268')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #269
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "''foo''", 'failed at #269')
endfunction
"}}}
function! s:suite.i_x_option_quoteescape() abort  "{{{
  " #270
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa\"bb', 'failed at #270')
endfunction
"}}}
function! s:suite.i_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #271
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #271')

  %delete

  " #272
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\naa\n", 'failed at #272')

  %delete

  " #273
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #273')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #274
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #274')

  %delete

  " #275
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #275')

  %delete

  " #276
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #276')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #277
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #277')

  %delete

  " #278
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjviby
  call g:assert.equals(@@, "\naa\n", 'failed at #278')

  %delete

  " #279
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #279')
endfunction
"}}}
function! s:suite.i_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #280
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #280')

  " #281
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #281')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #282
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #282')

  " #283
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '{', 'failed at #283')

endfunction
"}}}
function! s:suite.i_x_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #284
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #284')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #285
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #285')

  highlight link TestParen Special

  " #286
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #286')
endfunction
"}}}
function! s:suite.i_x_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #287
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'bar', 'failed at #287')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #288
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #288')

  highlight link TestParen Special

  " #289
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'bar', 'failed at #289')
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

  " #290
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #290')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #291
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #291')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #292
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #292')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #293
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #293')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #294
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #294')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #295
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #295')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #296
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '%s', 'failed at #296')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #297
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #297')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #298
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #298')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #299
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #299')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #300
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '%s', 'failed at #300')
endfunction
"}}}
function! s:suite.i_x_option_skip_break() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #301
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\nfoo\n", 'failed at #301')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'skip_break', 1)
  " #302
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "foo", 'failed at #302')

  %delete

  " #303
  call append(0, ['    (', '        foo', '    )'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "foo", 'failed at #303')

  %delete

  " #304
  " do not skip when any line breaking is not included.
  call setline('.', '(  foo  )')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, "  foo  ", 'failed at #304')
endfunction
"}}}
function! s:suite.i_x_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('auto', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #305
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aaa', 'failed at #305')

  %delete

  """ funcref
  call textobj#sandwich#set('auto', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #306
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aaa', 'failed at #306')
endfunction
"}}}
function! s:suite.i_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  " #307
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'b"c', 'failed at #307')

  " #308
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'aa(b', 'failed at #308')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #309
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "foo", 'failed at #309')

  " #310
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "foo''bar", 'failed at #310')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #311
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'oobarbaz', 'failed at #311')

  " #312
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bar', 'failed at #312')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #313
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #313')

  " #314
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #314')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #315
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #315')

  " #316
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #316')
endfunction
"}}}

function! s:suite.a_o_default_recipes() abort "{{{
  " #317
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(foo)', 'failed at #317')

  " #318
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '[foo]', 'failed at #318')

  " #319
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '{foo}', 'failed at #319')

  " #320
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '<foo>', 'failed at #320')

  " #321
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"foo"', 'failed at #321')

  " #322
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, "'foo'", 'failed at #322')
endfunction
"}}}
function! s:suite.a_o_nest() abort  "{{{
  " #323
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '()', 'failed at #323')

  " #324
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(a)', 'failed at #324')

  " #325
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #325')

  " #326
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #326')

  " #327
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #327')

  " #328
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #328')

  " #329
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #329')

  " #330
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #330')

  " #331
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '(cc)', 'failed at #331')

  " #332
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '(cc)', 'failed at #332')

  " #333
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '(cc)', 'failed at #333')

  " #334
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '(cc)', 'failed at #334')

  " #335
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #335')

  " #336
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #336')

  " #337
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #337')

  " #338
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #338')

  " #339
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #339')

  " #340
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #340')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #341
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #341')

  " #342
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #342')

  " #343
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #343')

  " #344
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #344')

  " #345
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #345')

  " #346
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #346')

  " #347
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #347')

  " #348
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #348')

  " #349
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #349')

  " #350
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #350')

  " #351
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #351')

  " #352
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #352')

  " #353
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #353')

  " #354
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #354')

  " #355
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #355')

  " #356
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #356')

  " #357
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #357')

  " #358
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #358')
endfunction
"}}}
function! s:suite.a_o_no_nest() abort "{{{
  " #359
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '""', 'failed at #359')

  " #360
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"a"', 'failed at #360')

  " #361
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #361')

  " #362
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '"aa"', 'failed at #362')

  " #363
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"aa"', 'failed at #363')

  " #364
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '"aa"', 'failed at #364')

  " #365
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '"bb"', 'failed at #365')

  " #366
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '"bb"', 'failed at #366')

  " #367
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '"cc"', 'failed at #367')

  " #368
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '"cc"', 'failed at #368')

  " #369
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '"cc"', 'failed at #369')

  " #370
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '"cc"', 'failed at #370')

  " #371
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '"bb"', 'failed at #371')

  " #372
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '"bb"', 'failed at #372')

  " #373
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '"aa"', 'failed at #373')

  " #374
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '"aa"', 'failed at #374')

  " #375
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '"aa"', 'failed at #375')

  " #376
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '"aa"', 'failed at #376')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #377
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"""aa"""', 'failed at #377')

  " #378
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #378')

  " #379
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #379')

  " #380
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #380')

  " #381
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #381')

  " #382
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #382')

  " #383
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #383')

  " #384
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #384')

  " #385
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '"""bb"""', 'failed at #385')

  " #386
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '"""bb"""', 'failed at #386')

  " #387
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #387')

  " #388
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #388')

  " #389
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #389')

  " #390
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #390')

  " #391
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #391')

  " #392
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #392')

  " #393
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #393')

  " #394
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #394')
endfunction
"}}}
function! s:suite.a_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #395
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #395')
endfunction
"}}}
function! s:suite.a_o_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #396
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, 'αbbα', 'failed at #396')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #397
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, 'aαbbaα', 'failed at #397')
endfunction
"}}}
function! s:suite.a_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #398
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #398')

  " #399
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #399')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #400
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #400')

  " #401
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '2aa3', 'failed at #401')

  " #402
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #402')

  " #403
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $yab
  call g:assert.equals(@@, '', 'failed at #403')

  " #404
  let g:textobj#sandwich#recipes = [{'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']}]
  call setline('.', 'headfootail')
  let @@ = 'fail'
  normal $yab
  call g:assert.equals(@@, 'headfootail', 'failed at #404')
endfunction
"}}}
function! s:suite.a_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #405
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #405')

  " #406
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #406')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #407
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #407')

  " #408
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '888aa888', 'failed at #408')
endfunction
"}}}
function! s:suite.a_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #409
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, 'afooa', 'failed at #409')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #410
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, 'afooaa', 'failed at #410')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #411
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'''foo'''", 'failed at #411')
endfunction
"}}}
function! s:suite.a_o_option_quoteescape() abort  "{{{
  " #412
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #412')
endfunction
"}}}
function! s:suite.a_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #413
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #413')

  %delete

  " #414
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #414')

  %delete

  " #415
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #415')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #416
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #416')

  %delete

  " #417
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #417')

  %delete

  " #418
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #418')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #419
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #419')

  %delete

  " #420
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyab
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #420')

  %delete

  " #421
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #421')
endfunction
"}}}
function! s:suite.a_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #422
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #422')

  " #423
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '{foo}', 'failed at #423')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #424
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #424')

  " #425
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #425')
endfunction
"}}}
function! s:suite.a_o_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #426
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #426')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #427
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #427')

  highlight link TestParen Special

  " #428
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #428')
endfunction
"}}}
function! s:suite.a_o_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #429
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(bar)', 'failed at #429')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #430
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #430')

  highlight link TestParen Special

  " #431
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(bar)', 'failed at #431')
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

  " #432
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #432')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #433
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #433')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #434
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #434')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #435
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #435')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #436
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #436')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #437
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #437')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #438
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"%s"', 'failed at #438')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #439
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #439')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #440
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #440')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #441
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #441')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #442
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"%s"', 'failed at #442')
endfunction
"}}}
function! s:suite.a_o_option_synchro() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'nesting': 1}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('auto', 'synchro', 1)
  nmap sd <Plug>(operator-sandwich-delete)

  " #443
  call setline('.', '(foo)')
  normal 0sdab
  call g:assert.equals(getline('.'), 'foo', 'failed at #443')

  " #444
  call setline('.', '((foo))')
  normal 0ff2sd2ab
  call g:assert.equals(getline('.'), 'foo', 'failed at #444')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]
  let g:operator#sandwich#recipes = []

  " #445
  call setline('.', '<bar>foo</bar>')
  normal 0sdab
  call g:assert.equals(getline('.'), 'foo', 'failed at #445')

  " #446
  call setline('.', '<baz><bar>foo</bar></baz>')
  normal 0ff2sd2ab
  call g:assert.equals(getline('.'), 'foo', 'failed at #446')
endfunction
"}}}
function! s:suite.a_o_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('auto', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #447
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, 'aaaaa', 'failed at #447')

  %delete

  """ funcref
  call textobj#sandwich#set('auto', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #448
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, 'aaaaa', 'failed at #448')
endfunction
"}}}
function! s:suite.a_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(((', ')))']}, {'buns': ['(', ')']}]

  " #449
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '(b"c)', 'failed at #449')

  " #450
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '"aa(b"', 'failed at #450')

  " #451
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '(foo)', 'failed at #451')

  " #452
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '(((foo)))', 'failed at #452')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #453
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'foo'", 'failed at #453')

  " #454
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'foo''bar'", 'failed at #454')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #455
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, 'foobarbaz', 'failed at #455')

  " #456
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '^bar$', 'failed at #456')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #457
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '2foo2', 'failed at #457')

  " #458
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '1+1foo1+1', 'failed at #458')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #459
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '[foo]', 'failed at #459')

  " #460
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '{foo}', 'failed at #460')
endfunction
"}}}

function! s:suite.a_x_default_recipes() abort "{{{
  " #461
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(foo)', 'failed at #461')

  " #462
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '[foo]', 'failed at #462')

  " #463
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '{foo}', 'failed at #463')

  " #464
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '<foo>', 'failed at #464')

  " #465
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"foo"', 'failed at #465')

  " #466
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, "'foo'", 'failed at #466')
endfunction
"}}}
function! s:suite.a_x_nest() abort  "{{{
  " #467
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '()', 'failed at #467')

  " #468
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(a)', 'failed at #468')

  " #469
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #469')

  " #470
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #470')

  " #471
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #471')

  " #472
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #472')

  " #473
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #473')

  " #474
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #474')

  " #475
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #475')

  " #476
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #476')

  " #477
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #477')

  " #478
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #478')

  " #479
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #479')

  " #480
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #480')

  " #481
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #481')

  " #482
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #482')

  " #483
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #483')

  " #484
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #484')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #485
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #485')

  " #486
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #486')

  " #487
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #487')

  " #488
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #488')

  " #489
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #489')

  " #490
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #490')

  " #491
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #491')

  " #492
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #492')

  " #493
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #493')

  " #494
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #494')

  " #495
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #495')

  " #496
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #496')

  " #497
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #497')

  " #498
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #498')

  " #499
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #499')

  " #500
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #500')

  " #501
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #501')

  " #502
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #502')
endfunction
"}}}
function! s:suite.a_x_no_nest() abort "{{{
  " #503
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '""', 'failed at #503')

  " #504
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"a"', 'failed at #504')

  " #505
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #505')

  " #506
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #506')

  " #507
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #507')

  " #508
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #508')

  " #509
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #509')

  " #510
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #510')

  " #511
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #511')

  " #512
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #512')

  " #513
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #513')

  " #514
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #514')

  " #515
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #515')

  " #516
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #516')

  " #517
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #517')

  " #518
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #518')

  " #519
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #519')

  " #520
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #520')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #521
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #521')

  " #522
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #522')

  " #523
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #523')

  " #524
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #524')

  " #525
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #525')

  " #526
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #526')

  " #527
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #527')

  " #528
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #528')

  " #529
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '"""bb"""', 'failed at #529')

  " #530
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '"""bb"""', 'failed at #530')

  " #531
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #531')

  " #532
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #532')

  " #533
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #533')

  " #534
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #534')

  " #535
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #535')

  " #536
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #536')

  " #537
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #537')

  " #538
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #538')
endfunction
"}}}
function! s:suite.a_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = []

  " #539
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #539')
endfunction
"}}}
function! s:suite.a_x_selected_area_extending() abort  "{{{
  " #540
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvaby
  call g:assert.equals(@@, '{cc}', 'failed at #540')

  " #541
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvababy
  call g:assert.equals(@@, '[bb{cc}bb]', 'failed at #541')

  " #542
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvabababy
  call g:assert.equals(@@, '(aa[bb{cc}bb]aa)', 'failed at #542')

  %delete

  " #543
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['if', 'endif'], 'nesting': 1},
        \   {'buns': ['if', 'else'], 'nesting': 1},
        \   {'buns': ['else', 'endif'], 'nesting': 1},
        \ ]
  call append(0, ['if', '  foo', '  foo', 'else', '  bar', '  bar', 'endif'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "if\n  foo\n  foo\nelse", 'failed at #543')

  " #544
  let @@ = 'fail'
  normal ggvababy
  call g:assert.equals(@@, "if\n  foo\n  foo\nelse\n  bar\n  bar\nendif", 'failed at #544')

  " #545
  let @@ = 'fail'
  normal 5Gvaby
  call g:assert.equals(@@, "else\n  bar\n  bar\nendif", 'failed at #545')

  " #546
  let @@ = 'fail'
  normal 5Gvababy
  call g:assert.equals(@@, "if\n  foo\n  foo\nelse\n  bar\n  bar\nendif", 'failed at #546')
endfunction
"}}}
function! s:suite.a_x_blockwise_visual() abort  "{{{
  " #548
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>aby"
  call g:assert.equals(@@, "( \naa\n  )", 'failed at #548')

  %delete

  " #549
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #549')

  %delete

  " #550
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #550')

  %delete

  " #551
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(ccc)", 'failed at #551')

  %delete

  " #552
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joaby"
  call g:assert.equals(@@, "(aaa)\n(bb)\n(cc)", 'failed at #552')
endfunction
"}}}
function! s:suite.a_x_multibyte() abort  "{{{
  let g:textobj#sandwich#recipes = [{'buns': ['α', 'α'], 'input': ['a']}]

  " #553
  call setline('.', 'aaαbbαaa')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, 'αbbα', 'failed at #553')

  let g:textobj#sandwich#recipes = [{'buns': ['aα', 'aα'], 'input': ['a']}]

  " #554
  call setline('.', 'aaαbbaαa')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, 'aαbbaα', 'failed at #554')
endfunction
"}}}
function! s:suite.a_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #555
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #555')

  " #556
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2', 'failed at #556')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #557
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '1', 'failed at #557')

  " #558
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2aa3', 'failed at #558')

  " #559
  let g:textobj#sandwich#recipes = [{'buns': ['SandwichExprEmpty()', '1+2']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2', 'failed at #559')

  " #560
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', 'SandwichExprEmpty()']}]
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal $vaby
  call g:assert.equals(@@, '3', 'failed at #560')

  " #561
  let g:textobj#sandwich#recipes = [{'buns': [function('SandwichExprBuns'), function('SandwichExprBuns')], 'expr': 1, 'input': ['d']}]
  call setline('.', 'headfootail')
  let @@ = 'fail'
  normal $vaby
  call g:assert.equals(@@, 'headfootail', 'failed at #561')
endfunction
"}}}
function! s:suite.a_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #562
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #562')

  " #563
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '8', 'failed at #563')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #564
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '\', 'failed at #564')

  " #565
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '888aa888', 'failed at #565')
endfunction
"}}}
function! s:suite.a_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #566
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'afooa', 'failed at #566')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #567
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'afooaa', 'failed at #567')

  """ head and tail
  let g:textobj#sandwich#recipes = [{'buns': ["'", "'"]}]
  call textobj#sandwich#set('auto', 'skip_regex_head', ['\%(\%#\zs''\|''\%#\zs\)''\%(''''\)*[^'']'])
  call textobj#sandwich#set('auto', 'skip_regex_tail', ['[^'']\%(''''\)*\%(\%#\zs''\|''\%#\zs\)'''])
  " #568
  call setline('.', "'''foo'''")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'''foo'''", 'failed at #568')
endfunction
"}}}
function! s:suite.a_x_option_quoteescape() abort  "{{{
  " #569
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #569')
endfunction
"}}}
function! s:suite.a_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #570
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #570')

  %delete

  " #571
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #571')

  %delete

  " #572
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #572')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #573
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #573')

  %delete

  " #574
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #574')

  %delete

  " #575
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #575')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #576
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #576')

  %delete

  " #577
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvaby
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #577')

  %delete

  " #578
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #578')
endfunction
"}}}
function! s:suite.a_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #579
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #579')

  " #580
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{foo}', 'failed at #580')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #581
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #581')

  " #582
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{', 'failed at #582')
endfunction
"}}}
function! s:suite.a_x_option_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #583
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #583')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #584
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #584')

  highlight link TestParen Special

  " #585
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #585')
endfunction
"}}}
function! s:suite.a_x_option_inner_syntax() abort "{{{
  syntax enable
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'inner_syntax', [])

  " #586
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(bar)', 'failed at #586')

  call textobj#sandwich#set('auto', 'inner_syntax', ['Special'])
  syn match TestParen '[br]'
  highlight link TestParen String

  " #587
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #587')

  highlight link TestParen Special

  " #588
  call setline('.', '(bar)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(bar)', 'failed at #588')
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

  " #589
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #589')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #590
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #590')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #591
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #591')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #592
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #592')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #593
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #593')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #594
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #594')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #595
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"%s"', 'failed at #595')

  """ 3
  call textobj#sandwich#set('auto', 'match_syntax', 3)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #596
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #596')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #597
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #597')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #598
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #598')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #599
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"%s"', 'failed at #599')
endfunction
"}}}
function! s:suite.a_x_option_skip_expr() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ expression
  call textobj#sandwich#set('auto', 'skip_expr', ['!(getpos(".")[2] == 1) && !(getpos(".")[2] == col([getpos(".")[1], "$"])-1)'])
  " #600
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, 'aaaaa', 'failed at #600')

  %delete

  """ funcref
  call textobj#sandwich#set('auto', 'skip_expr', [function('SandwichSkipIntermediate')])
  " #601
  call setline('.', 'aaaaa')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, 'aaaaa', 'failed at #601')
endfunction
"}}}
function! s:suite.a_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(((', ')))']}, {'buns': ['(', ')']}]

  " #602
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '(b"c)', 'failed at #602')

  " #603
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '"aa(b"', 'failed at #603')

  " #604
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(foo)', 'failed at #604')

  " #605
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(((foo)))', 'failed at #605')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #606
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'foo'", 'failed at #606')

  " #607
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'foo''bar'", 'failed at #607')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #608
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, 'foobarbaz', 'failed at #608')

  " #609
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '^bar$', 'failed at #609')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #610
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '2foo2', 'failed at #610')

  " #611
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '1+1foo1+1', 'failed at #611')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #612
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '[foo]', 'failed at #612')

  " #613
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '{foo}', 'failed at #613')
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

  " #614
  call setline('.', '"foo\""')
  normal 0dib
  call g:assert.equals(getline('.'), '""', 'failed at #614')

  " #615
  call setline('.', '(foo)')
  normal 0dib
  call g:assert.equals(getline('.'), '(foo)', 'failed at #615')

  " #616
  call setline('.', '[foo]')
  normal 0dib
  call g:assert.equals(getline('.'), '[]', 'failed at #616')

  " #617
  call setline('.', '"foo\""')
  normal 0diib
  call g:assert.equals(getline('.'), '"""', 'failed at #617')

  " #618
  call setline('.', '(foo)')
  normal 0diib
  call g:assert.equals(getline('.'), '()', 'failed at #618')

  " #619
  call setline('.', '[foo]')
  normal 0diib
  call g:assert.equals(getline('.'), '[foo]', 'failed at #619')
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

  " #620
  call setline('.', '"foo\""')
  normal 0dab
  call g:assert.equals(getline('.'), '', 'failed at #620')

  " #621
  call setline('.', '(foo)')
  normal 0dab
  call g:assert.equals(getline('.'), '(foo)', 'failed at #621')

  " #622
  call setline('.', '[foo]')
  normal 0dab
  call g:assert.equals(getline('.'), '', 'failed at #622')

  " #623
  call setline('.', '"foo\""')
  normal 0daab
  call g:assert.equals(getline('.'), '"', 'failed at #623')

  " #624
  call setline('.', '(foo)')
  normal 0daab
  call g:assert.equals(getline('.'), '', 'failed at #624')

  " #625
  call setline('.', '[foo]')
  normal 0daab
  call g:assert.equals(getline('.'), '[foo]', 'failed at #625')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
