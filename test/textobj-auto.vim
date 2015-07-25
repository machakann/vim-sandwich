let s:suite = themis#suite('textobj-sandwich: auto:')

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
endfunction
"}}}
function! s:suite.i_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #102
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #102')

  " #103
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #103')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #104
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #104')

  " #105
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #105')
endfunction
"}}}
function! s:suite.i_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #106
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #106')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #107
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'fooa', 'failed at #107')
endfunction
"}}}
function! s:suite.i_o_option_quoteescape() abort  "{{{
  " #108
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa\"bb', 'failed at #108')
endfunction
"}}}
function! s:suite.i_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #109
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #109')

  %delete

  " #110
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\naa\n", 'failed at #110')

  %delete

  " #111
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #111')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
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
  call g:assert.equals(@@, '', 'failed at #113')

  %delete

  " #114
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #114')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #115
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #115')

  %delete

  " #116
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyib
  call g:assert.equals(@@, "\naa\n", 'failed at #116')

  %delete

  " #117
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #117')
endfunction
"}}}
function! s:suite.i_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #118
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #118')

  " #119
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #119')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #120
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #120')

  " #121
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #121')
endfunction
"}}}
function! s:suite.i_o_option_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #122
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #122')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #123
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #123')

  highlight link TestParen Special

  " #124
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #124')
endfunction
"}}}
function! s:suite.i_o_option_match_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}, {'buns': ['"', '"']}]

  """ 1
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #125
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #125')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #126
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #126')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #127
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #127')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #128
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #128')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #129
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #129')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #130
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #130')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #131
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '%s', 'failed at #131')
endfunction
"}}}
function! s:suite.i_o_option_skip_breaking() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #132
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\nfoo\n", 'failed at #132')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'skip_break', 1)
  " #133
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "foo", 'failed at #133')
endfunction
"}}}
function! s:suite.i_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  " #134
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'b"c', 'failed at #134')

  " #135
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'aa(b', 'failed at #135')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #136
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, "foo", 'failed at #136')

  " #137
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, "foo''bar", 'failed at #137')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #138
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'oobarbaz', 'failed at #138')

  " #139
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'bar', 'failed at #139')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #140
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #140')

  " #141
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #141')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #142
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #142')

  " #143
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffyib
  call g:assert.equals(@@, 'foo', 'failed at #143')
endfunction
"}}}

function! s:suite.i_x_default_recipes() abort "{{{
  " #144
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #144')

  " #145
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #145')

  " #146
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #146')

  " #147
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #147')

  " #148
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #148')

  " #149
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #149')
endfunction
"}}}
function! s:suite.i_x_nest() abort  "{{{
  " #150
  call setline('.', '()')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #150')

  " #151
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'a', 'failed at #151')

  " #152
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #152')

  " #153
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #153')

  " #154
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #154')

  " #155
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #155')

  " #156
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #156')

  " #157
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #157')

  " #158
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'cc', 'failed at #158')

  " #159
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'cc', 'failed at #159')

  " #160
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'cc', 'failed at #160')

  " #161
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'cc', 'failed at #161')

  " #162
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #162')

  " #163
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #163')

  " #164
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #164')

  " #165
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #165')

  " #166
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #166')

  " #167
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #167')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #168
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #168')

  " #169
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #169')

  " #170
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #170')

  " #171
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #171')

  " #172
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #172')

  " #173
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb', 'failed at #173')

  " #174
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'bb', 'failed at #174')

  " #175
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'bb', 'failed at #175')

  " #176
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'bb', 'failed at #176')

  " #177
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'bb', 'failed at #177')

  " #178
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb', 'failed at #178')

  " #179
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb', 'failed at #179')

  " #180
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'bb', 'failed at #180')

  " #181
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #181')

  " #182
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #182')

  " #183
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #183')

  " #184
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #184')

  " #185
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #185')
endfunction
"}}}
function! s:suite.i_x_no_nest() abort "{{{
  " #186
  call setline('.', '""')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '"', 'failed at #186')

  " #187
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'a', 'failed at #187')

  " #188
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #188')

  " #189
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa', 'failed at #189')

  " #190
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa', 'failed at #190')

  " #191
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa', 'failed at #191')

  " #192
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'bb', 'failed at #192')

  " #193
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb', 'failed at #193')

  " #194
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'cc', 'failed at #194')

  " #195
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'cc', 'failed at #195')

  " #196
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'cc', 'failed at #196')

  " #197
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'cc', 'failed at #197')

  " #198
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb', 'failed at #198')

  " #199
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb', 'failed at #199')

  " #200
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'aa', 'failed at #200')

  " #201
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa', 'failed at #201')

  " #202
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa', 'failed at #202')

  " #203
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa', 'failed at #203')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #204
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #204')

  " #205
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa', 'failed at #205')

  " #206
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa', 'failed at #206')

  " #207
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa', 'failed at #207')

  " #208
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'aa', 'failed at #208')

  " #209
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'aa', 'failed at #209')

  " #210
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'aa', 'failed at #210')

  " #211
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'aa', 'failed at #211')

  " #212
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'bb', 'failed at #212')

  " #213
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'bb', 'failed at #213')

  " #214
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'cc', 'failed at #214')

  " #215
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'cc', 'failed at #215')

  " #216
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'cc', 'failed at #216')

  " #217
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'cc', 'failed at #217')

  " #218
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'cc', 'failed at #218')

  " #219
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'cc', 'failed at #219')

  " #220
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lviby
  call g:assert.equals(@@, 'cc', 'failed at #220')

  " #221
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lviby
  call g:assert.equals(@@, 'cc', 'failed at #221')
endfunction
"}}}
function! s:suite.i_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #222
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bb', 'failed at #222')
endfunction
"}}}
function! s:suite.i_x_selected_area_extending() abort  "{{{
  " #223
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcviby
  call g:assert.equals(@@, 'cc', 'failed at #223')

  " #224
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvibiby
  call g:assert.equals(@@, 'bb{cc}bb', 'failed at #224')

  " #225
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvibibiby
  call g:assert.equals(@@, 'aa[bb{cc}bb]aa', 'failed at #225')
endfunction
"}}}
function! s:suite.i_x_blockwise_visual() abort  "{{{
  " #226
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>iby"
  call g:assert.equals(@@, " \na\n ", 'failed at #226')

  %delete

  " #227
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jiby"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #227')

  %delete

  " #228
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joiby"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #228')

  %delete

  " #229
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jiby"
  call g:assert.equals(@@, "aa)\nbb)\nccc", 'failed at #229')

  %delete

  " #230
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joiby"
  call g:assert.equals(@@, "aaa\nbb)\ncc)", 'failed at #230')
endfunction
"}}}
function! s:suite.i_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #231
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #231')

  " #232
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '2', 'failed at #232')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #233
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '1', 'failed at #233')

  " #234
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #234')
endfunction
"}}}
function! s:suite.i_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #235
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #235')

  " #236
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '8', 'failed at #236')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #237
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '\', 'failed at #237')

  " #238
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #238')
endfunction
"}}}
function! s:suite.i_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #239
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #239')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #240
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'fooa', 'failed at #240')
endfunction
"}}}
function! s:suite.i_x_option_quoteescape() abort  "{{{
  " #241
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa\"bb', 'failed at #241')
endfunction
"}}}
function! s:suite.i_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #242
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #242')

  %delete

  " #243
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\naa\n", 'failed at #243')

  %delete

  " #244
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #244')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #245
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #245')

  %delete

  " #246
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #246')

  %delete

  " #247
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #247')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #248
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #248')

  %delete

  " #249
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjviby
  call g:assert.equals(@@, "\naa\n", 'failed at #249')

  %delete

  " #250
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #250')
endfunction
"}}}
function! s:suite.i_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #251
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #251')

  " #252
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #252')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #253
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #253')

  " #254
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '{', 'failed at #254')

endfunction
"}}}
function! s:suite.i_x_option_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #255
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #255')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #256
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #256')

  highlight link TestParen Special

  " #257
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #257')
endfunction
"}}}
function! s:suite.i_x_option_match_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}, {'buns': ['"', '"']}]

  """ 1
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #258
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #258')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #259
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #259')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #260
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #260')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #261
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #261')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #262
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #262')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #263
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #263')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #264
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '%s', 'failed at #264')
endfunction
"}}}
function! s:suite.i_o_option_skip_breaking() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #265
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\nfoo\n", 'failed at #265')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'skip_break', 1)
  " #266
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "foo", 'failed at #266')
endfunction
"}}}
function! s:suite.i_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  " #267
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'b"c', 'failed at #267')

  " #268
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'aa(b', 'failed at #268')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #269
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "foo", 'failed at #269')

  " #270
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, "foo''bar", 'failed at #270')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #271
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'oobarbaz', 'failed at #271')

  " #272
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bar', 'failed at #272')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #273
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #273')

  " #274
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #274')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #275
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #275')

  " #276
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffviby
  call g:assert.equals(@@, 'foo', 'failed at #276')
endfunction
"}}}

function! s:suite.a_o_default_recipes() abort "{{{
  " #277
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(foo)', 'failed at #277')

  " #278
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '[foo]', 'failed at #278')

  " #279
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '{foo}', 'failed at #279')

  " #280
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '<foo>', 'failed at #280')

  " #281
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"foo"', 'failed at #281')

  " #282
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, "'foo'", 'failed at #282')
endfunction
"}}}
function! s:suite.a_o_nest() abort  "{{{
  " #283
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '()', 'failed at #283')

  " #284
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(a)', 'failed at #284')

  " #285
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #285')

  " #286
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #286')

  " #287
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #287')

  " #288
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #288')

  " #289
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #289')

  " #290
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #290')

  " #291
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '(cc)', 'failed at #291')

  " #292
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '(cc)', 'failed at #292')

  " #293
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '(cc)', 'failed at #293')

  " #294
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '(cc)', 'failed at #294')

  " #295
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #295')

  " #296
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #296')

  " #297
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #297')

  " #298
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #298')

  " #299
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #299')

  " #300
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #300')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #301
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #301')

  " #302
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #302')

  " #303
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #303')

  " #304
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #304')

  " #305
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #305')

  " #306
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #306')

  " #307
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #307')

  " #308
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #308')

  " #309
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #309')

  " #310
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #310')

  " #311
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #311')

  " #312
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #312')

  " #313
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #313')

  " #314
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #314')

  " #315
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #315')

  " #316
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #316')

  " #317
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #317')

  " #318
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #318')
endfunction
"}}}
function! s:suite.a_o_no_nest() abort "{{{
  " #319
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '""', 'failed at #319')

  " #320
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"a"', 'failed at #320')

  " #321
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #321')

  " #322
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '"aa"', 'failed at #322')

  " #323
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"aa"', 'failed at #323')

  " #324
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '"aa"', 'failed at #324')

  " #325
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '"bb"', 'failed at #325')

  " #326
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '"bb"', 'failed at #326')

  " #327
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '"cc"', 'failed at #327')

  " #328
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '"cc"', 'failed at #328')

  " #329
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '"cc"', 'failed at #329')

  " #330
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '"cc"', 'failed at #330')

  " #331
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '"bb"', 'failed at #331')

  " #332
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '"bb"', 'failed at #332')

  " #333
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '"aa"', 'failed at #333')

  " #334
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '"aa"', 'failed at #334')

  " #335
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '"aa"', 'failed at #335')

  " #336
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '"aa"', 'failed at #336')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #337
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"""aa"""', 'failed at #337')

  " #338
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #338')

  " #339
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #339')

  " #340
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #340')

  " #341
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #341')

  " #342
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #342')

  " #343
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #343')

  " #344
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #344')

  " #345
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '"""bb"""', 'failed at #345')

  " #346
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '"""bb"""', 'failed at #346')

  " #347
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #347')

  " #348
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #348')

  " #349
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #349')

  " #350
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #350')

  " #351
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #351')

  " #352
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #352')

  " #353
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #353')

  " #354
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #354')
endfunction
"}}}
function! s:suite.a_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #355
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #355')
endfunction
"}}}
function! s:suite.a_o_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #356
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #356')

  " #357
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #357')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #358
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #358')

  " #359
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '2aa3', 'failed at #359')
endfunction
"}}}
function! s:suite.a_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #360
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #360')

  " #361
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #361')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #362
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #362')

  " #363
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '888aa888', 'failed at #363')
endfunction
"}}}
function! s:suite.a_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #364
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, 'afooa', 'failed at #364')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #365
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, 'afooaa', 'failed at #365')
endfunction
"}}}
function! s:suite.a_o_option_quoteescape() abort  "{{{
  " #366
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #366')
endfunction
"}}}
function! s:suite.a_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #367
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #367')

  %delete

  " #368
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #368')

  %delete

  " #369
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #369')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #370
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #370')

  %delete

  " #371
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #371')

  %delete

  " #372
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #372')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #373
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #373')

  %delete

  " #374
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyab
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #374')

  %delete

  " #375
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #375')
endfunction
"}}}
function! s:suite.a_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #376
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #376')

  " #377
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '{foo}', 'failed at #377')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #378
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #378')

  " #379
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #379')
endfunction
"}}}
function! s:suite.a_o_option_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #380
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #380')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #381
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #381')

  highlight link TestParen Special

  " #382
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #382')
endfunction
"}}}
function! s:suite.a_o_option_match_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}, {'buns': ['"', '"']}]

  """ 1
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #383
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #383')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #384
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #384')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #385
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #385')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #386
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #386')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #387
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #387')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #388
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #388')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #389
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"%s"', 'failed at #389')
endfunction
"}}}
function! s:suite.a_o_option_synchro() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')'], 'nesting': 1}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('auto', 'synchro', 1)
  nmap sd <Plug>(operator-sandwich-delete)

  " #390
  call setline('.', '(foo)')
  normal 0sdab
  call g:assert.equals(getline('.'), 'foo', 'failed at #390')

  " #391
  call setline('.', '((foo))')
  normal 0ff2sd2ab
  call g:assert.equals(getline('.'), 'foo', 'failed at #391')
endfunction
"}}}
function! s:suite.a_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(((', ')))']}, {'buns': ['(', ')']}]

  " #392
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '(b"c)', 'failed at #392')

  " #393
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '"aa(b"', 'failed at #393')

  " #394
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '(foo)', 'failed at #394')

  " #395
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '(((foo)))', 'failed at #395')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #396
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'foo'", 'failed at #396')

  " #397
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, "'foo''bar'", 'failed at #397')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #398
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, 'foobarbaz', 'failed at #398')

  " #399
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '^bar$', 'failed at #399')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #400
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '2foo2', 'failed at #400')

  " #401
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '1+1foo1+1', 'failed at #401')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #402
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '[foo]', 'failed at #402')

  " #403
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '{foo}', 'failed at #403')
endfunction
"}}}

function! s:suite.a_x_default_recipes() abort "{{{
  " #404
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(foo)', 'failed at #404')

  " #405
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '[foo]', 'failed at #405')

  " #406
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '{foo}', 'failed at #406')

  " #407
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '<foo>', 'failed at #407')

  " #408
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"foo"', 'failed at #408')

  " #409
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, "'foo'", 'failed at #409')
endfunction
"}}}
function! s:suite.a_x_nest() abort  "{{{
  " #410
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '()', 'failed at #410')

  " #411
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(a)', 'failed at #411')

  " #412
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #412')

  " #413
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #413')

  " #414
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #414')

  " #415
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #415')

  " #416
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #416')

  " #417
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #417')

  " #418
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #418')

  " #419
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #419')

  " #420
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #420')

  " #421
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #421')

  " #422
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #422')

  " #423
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #423')

  " #424
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #424')

  " #425
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #425')

  " #426
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #426')

  " #427
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #427')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #428
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #428')

  " #429
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #429')

  " #430
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #430')

  " #431
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #431')

  " #432
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #432')

  " #433
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #433')

  " #434
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #434')

  " #435
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #435')

  " #436
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #436')

  " #437
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #437')

  " #438
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #438')

  " #439
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #439')

  " #440
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #440')

  " #441
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #441')

  " #442
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #442')

  " #443
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #443')

  " #444
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #444')

  " #445
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #445')
endfunction
"}}}
function! s:suite.a_x_no_nest() abort "{{{
  " #446
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '""', 'failed at #446')

  " #447
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"a"', 'failed at #447')

  " #448
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #448')

  " #449
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #449')

  " #450
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #450')

  " #451
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #451')

  " #452
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #452')

  " #453
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #453')

  " #454
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #454')

  " #455
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #455')

  " #456
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #456')

  " #457
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #457')

  " #458
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #458')

  " #459
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #459')

  " #460
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #460')

  " #461
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #461')

  " #462
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #462')

  " #463
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #463')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #464
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #464')

  " #465
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #465')

  " #466
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #466')

  " #467
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #467')

  " #468
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #468')

  " #469
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #469')

  " #470
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #470')

  " #471
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #471')

  " #472
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '"""bb"""', 'failed at #472')

  " #473
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '"""bb"""', 'failed at #473')

  " #474
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #474')

  " #475
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #475')

  " #476
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #476')

  " #477
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #477')

  " #478
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #478')

  " #479
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #479')

  " #480
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #480')

  " #481
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #481')
endfunction
"}}}
function! s:suite.a_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = []

  " #482
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #482')
endfunction
"}}}
function! s:suite.a_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(((', ')))']}, {'buns': ['(', ')']}]

  " #483
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '(b"c)', 'failed at #483')

  " #484
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '"aa(b"', 'failed at #484')

  " #485
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(foo)', 'failed at #485')

  " #486
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(((foo)))', 'failed at #486')
endfunction
"}}}
function! s:suite.a_x_selected_area_extending() abort  "{{{
  " #487
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvaby
  call g:assert.equals(@@, '{cc}', 'failed at #487')

  " #488
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvababy
  call g:assert.equals(@@, '[bb{cc}bb]', 'failed at #488')

  " #489
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvabababy
  call g:assert.equals(@@, '(aa[bb{cc}bb]aa)', 'failed at #489')
endfunction
"}}}
function! s:suite.a_x_blockwise_visual() abort  "{{{
  " #490
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>aby"
  call g:assert.equals(@@, "( \naa\n  )", 'failed at #490')

  %delete

  " #491
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #491')

  %delete

  " #492
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #492')

  %delete

  " #493
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(ccc)", 'failed at #493')

  %delete

  " #494
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joaby"
  call g:assert.equals(@@, "(aaa)\n(bb)\n(cc)", 'failed at #494')
endfunction
"}}}
function! s:suite.a_x_option_expr() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #495
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #495')

  " #496
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2', 'failed at #496')

  """ on
  call textobj#sandwich#set('auto', 'expr', 1)
  " #497
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '1', 'failed at #497')

  " #498
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2aa3', 'failed at #498')
endfunction
"}}}
function! s:suite.a_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #499
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #499')

  " #500
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '8', 'failed at #500')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #501
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '\', 'failed at #501')

  " #502
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '888aa888', 'failed at #502')
endfunction
"}}}
function! s:suite.a_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #503
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'afooa', 'failed at #503')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #504
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'afooaa', 'failed at #504')
endfunction
"}}}
function! s:suite.a_x_option_quoteescape() abort  "{{{
  " #505
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #505')
endfunction
"}}}
function! s:suite.a_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #506
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #506')

  %delete

  " #507
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #507')

  %delete

  " #508
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #508')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #509
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #509')

  %delete

  " #510
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #510')

  %delete

  " #511
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #511')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #512
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #512')

  %delete

  " #513
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvaby
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #513')

  %delete

  " #514
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #514')
endfunction
"}}}
function! s:suite.a_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #515
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #515')

  " #516
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{foo}', 'failed at #516')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #517
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #517')

  " #518
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{', 'failed at #518')
endfunction
"}}}
function! s:suite.a_x_option_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #519
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #519')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #520
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #520')

  highlight link TestParen Special

  " #521
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #521')
endfunction
"}}}
function! s:suite.a_x_option_match_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}, {'buns': ['"', '"']}]

  """ 1
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #522
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #522')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #523
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #523')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #524
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #524')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #525
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #525')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #526
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #526')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #527
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #527')

  syntax clear
  syntax match TestString '".*"' contains=TestSpecialString
  syntax match TestSpecialString '%s'
  highlight link TestString String
  highlight link TestSpecialString Special

  " #528
  call setline('.', '"%s"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"%s"', 'failed at #528')
endfunction
"}}}
function! s:suite.a_x_option_synchro() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('auto', 'synchro', 1)
  xmap sd <Plug>(operator-sandwich-delete)

  " #529
  call setline('.', 'afooa')
  normal 0vabsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #529')
endfunction
"}}}
function! s:suite.a_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(((', ')))']}, {'buns': ['(', ')']}]

  " #530
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '(b"c)', 'failed at #530')

  " #531
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '"aa(b"', 'failed at #531')

  " #532
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(foo)', 'failed at #532')

  " #533
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(((foo)))', 'failed at #533')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ["'", "'"]},
        \   {'buns': ["'", "'"], 'filetype': ['vim'], 'skip_regex': ['[^'']\%(''''\)*\zs''''', '[^'']\%(''''\)*''\zs''']}
        \ ]

  " #534
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'foo'", 'failed at #534')

  " #535
  set filetype=vim
  call setline('.', "'foo''bar'")
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, "'foo''bar'", 'failed at #535')

  set filetype=
  let g:textobj#sandwich#recipes = [
        \   {'buns': ['^', '$']},
        \   {'buns': ['^', '$'], 'regex': 1}
        \ ]

  " #536
  call setline('.', 'foobarbaz')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, 'foobarbaz', 'failed at #536')

  " #537
  call setline('.', 'foo^bar$baz')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '^bar$', 'failed at #537')

  let g:textobj#sandwich#recipes = [
        \   {'buns': ['1+1', '1+1']},
        \   {'buns': ['1+1', '1+1'], 'expr': 1}
        \ ]

  " #538
  call setline('.', '1+12foo21+1')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '2foo2', 'failed at #538')

  " #539
  call setline('.', '21+1foo1+12')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '1+1foo1+1', 'failed at #539')

  let g:textobj#sandwich#recipes = [
        \   {'external': ['i{', 'a{']},
        \   {'external': ['i{', 'a{'], 'noremap': 0}
        \ ]
  xnoremap i{ i[
  xnoremap a{ a[

  " #540
  call setline('.', '{[foo]}')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '[foo]', 'failed at #540')

  " #541
  call setline('.', '[{foo}]')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '{foo}', 'failed at #541')
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

  " #542
  call setline('.', '"foo\""')
  normal 0dib
  call g:assert.equals(getline('.'), '""', 'failed at #542')

  " #543
  call setline('.', '(foo)')
  normal 0dib
  call g:assert.equals(getline('.'), '(foo)', 'failed at #543')

  " #544
  call setline('.', '[foo]')
  normal 0dib
  call g:assert.equals(getline('.'), '[]', 'failed at #544')

  " #545
  call setline('.', '"foo\""')
  normal 0diib
  call g:assert.equals(getline('.'), '"""', 'failed at #545')

  " #546
  call setline('.', '(foo)')
  normal 0diib
  call g:assert.equals(getline('.'), '()', 'failed at #546')

  " #547
  call setline('.', '[foo]')
  normal 0diib
  call g:assert.equals(getline('.'), '[foo]', 'failed at #547')
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

  " #548
  call setline('.', '"foo\""')
  normal 0dab
  call g:assert.equals(getline('.'), '', 'failed at #548')

  " #549
  call setline('.', '(foo)')
  normal 0dab
  call g:assert.equals(getline('.'), '(foo)', 'failed at #549')

  " #550
  call setline('.', '[foo]')
  normal 0dab
  call g:assert.equals(getline('.'), '', 'failed at #550')

  " #551
  call setline('.', '"foo\""')
  normal 0daab
  call g:assert.equals(getline('.'), '"', 'failed at #551')

  " #552
  call setline('.', '(foo)')
  normal 0daab
  call g:assert.equals(getline('.'), '', 'failed at #552')

  " #553
  call setline('.', '[foo]')
  normal 0daab
  call g:assert.equals(getline('.'), '[foo]', 'failed at #553')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
