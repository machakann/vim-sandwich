let s:suite = themis#suite('textobj-sandwich: auto:')

function! s:suite.before_each() abort "{{{
  %delete
  set virtualedit&
  set whichwrap&
  call textobj#sandwich#set_default()
  unlet! g:sandwich#recipes
  unlet! g:textobj#sandwich#recipes
  silent! xunmap i{
  silent! xunmap a{
endfunction
"}}}
function! s:suite.after() abort "{{{
  call s:suite.before_each()
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
  " #7
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #7')

  " #8
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'a', 'failed at #8')

  " #9
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #9')

  " #10
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #10')

  " #11
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #11')

  " #12
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #12')

  " #13
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #13')

  " #14
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #14')

  " #15
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'cc', 'failed at #15')

  " #16
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'cc', 'failed at #16')

  " #17
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'cc', 'failed at #17')

  " #18
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'cc', 'failed at #18')

  " #19
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #19')

  " #20
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #20')

  " #21
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #21')

  " #22
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #22')

  " #23
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #23')

  " #24
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #24')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #25
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #25')

  " #26
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #26')

  " #27
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #27')

  " #28
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #28')

  " #29
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #29')

  " #30
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'bb', 'failed at #30')

  " #31
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'bb', 'failed at #31')

  " #32
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'bb', 'failed at #32')

  " #33
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'bb', 'failed at #33')

  " #34
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'bb', 'failed at #34')

  " #35
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'bb', 'failed at #35')

  " #36
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'bb', 'failed at #36')

  " #37
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'bb', 'failed at #37')

  " #38
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #38')

  " #39
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #39')

  " #40
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #40')

  " #41
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #41')

  " #42
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyib
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #42')
endfunction
"}}}
function! s:suite.i_o_no_nest() abort "{{{
  " #43
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #43')

  " #44
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'a', 'failed at #44')

  " #45
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #45')

  " #46
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa', 'failed at #46')

  " #47
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa', 'failed at #47')

  " #48
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'aa', 'failed at #48')

  " #49
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'bb', 'failed at #49')

  " #50
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'bb', 'failed at #50')

  " #51
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'cc', 'failed at #51')

  " #52
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'cc', 'failed at #52')

  " #53
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'cc', 'failed at #53')

  " #54
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'cc', 'failed at #54')

  " #55
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'bb', 'failed at #55')

  " #56
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'bb', 'failed at #56')

  " #57
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'aa', 'failed at #57')

  " #58
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'aa', 'failed at #58')

  " #59
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'aa', 'failed at #59')

  " #60
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'aa', 'failed at #60')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #61
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #61')

  " #62
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyib
  call g:assert.equals(@@, 'aa', 'failed at #62')

  " #63
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyib
  call g:assert.equals(@@, 'aa', 'failed at #63')

  " #64
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyib
  call g:assert.equals(@@, 'aa', 'failed at #64')

  " #65
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyib
  call g:assert.equals(@@, 'aa', 'failed at #65')

  " #66
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyib
  call g:assert.equals(@@, 'aa', 'failed at #66')

  " #67
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyib
  call g:assert.equals(@@, 'aa', 'failed at #67')

  " #68
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyib
  call g:assert.equals(@@, 'aa', 'failed at #68')

  " #69
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyib
  call g:assert.equals(@@, 'bb', 'failed at #69')

  " #70
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyib
  call g:assert.equals(@@, 'bb', 'failed at #70')

  " #71
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyib
  call g:assert.equals(@@, 'cc', 'failed at #71')

  " #72
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyib
  call g:assert.equals(@@, 'cc', 'failed at #72')

  " #73
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyib
  call g:assert.equals(@@, 'cc', 'failed at #73')

  " #74
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyib
  call g:assert.equals(@@, 'cc', 'failed at #74')

  " #75
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyib
  call g:assert.equals(@@, 'cc', 'failed at #75')

  " #76
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyib
  call g:assert.equals(@@, 'cc', 'failed at #76')

  " #77
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyib
  call g:assert.equals(@@, 'cc', 'failed at #77')

  " #78
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyib
  call g:assert.equals(@@, 'cc', 'failed at #78')
endfunction
"}}}
function! s:suite.i_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #79
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'bb', 'failed at #79')
endfunction
"}}}
function! s:suite.i_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  " #80
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'b"c', 'failed at #80')

  " #81
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbyib
  call g:assert.equals(@@, 'aa(b', 'failed at #81')
endfunction
"}}}
function! s:suite.i_o_option_eval() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #82
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #82')

  " #83
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #83')

  """ on
  call textobj#sandwich#set('auto', 'eval', 1)
  " #84
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #84')

  " #85
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #85')
endfunction
"}}}
function! s:suite.i_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #86
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #86')

  " #87
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #87')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #88
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #88')

  " #89
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #89')
endfunction
"}}}
function! s:suite.i_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #90
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #90')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #91
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'fooa', 'failed at #91')
endfunction
"}}}
function! s:suite.i_o_option_quoteescape() abort  "{{{
  " #92
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa\"bb', 'failed at #92')
endfunction
"}}}
function! s:suite.i_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #93
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #93')

  %delete

  " #94
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\naa\n", 'failed at #94')

  %delete

  " #95
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #95')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #96
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #96')

  %delete

  " #97
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #97')

  %delete

  " #98
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #98')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #99
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'aa', 'failed at #99')

  %delete

  " #100
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyib
  call g:assert.equals(@@, "\naa\n", 'failed at #100')

  %delete

  " #101
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, '', 'failed at #101')
endfunction
"}}}
function! s:suite.i_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #102
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #102')

  " #103
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #103')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #104
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #104')

  " #105
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #105')
endfunction
"}}}
function! s:suite.i_o_option_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #106
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #106')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #107
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #107')

  highlight link TestParen Special

  " #108
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #108')
endfunction
"}}}
function! s:suite.i_o_option_match_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 1
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #109
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #109')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #110
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #110')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #111
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #111')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #112
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #112')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #113
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, '', 'failed at #113')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #114
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yib
  call g:assert.equals(@@, 'foo', 'failed at #114')
endfunction
"}}}
function! s:suite.i_o_option_skip_breaking() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #115
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "\nfoo\n", 'failed at #115')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'skip_break', 1)
  " #116
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggyib
  call g:assert.equals(@@, "foo", 'failed at #116')
endfunction
"}}}

function! s:suite.i_x_default_recipes() abort "{{{
  " #117
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #117')

  " #118
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #118')

  " #119
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #119')

  " #120
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #120')

  " #121
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #121')

  " #122
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'foo', 'failed at #122')
endfunction
"}}}
function! s:suite.i_x_nest() abort  "{{{
  " #123
  call setline('.', '()')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #123')

  " #124
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'a', 'failed at #124')

  " #125
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #125')

  " #126
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #126')

  " #127
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #127')

  " #128
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #128')

  " #129
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #129')

  " #130
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #130')

  " #131
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'cc', 'failed at #131')

  " #132
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'cc', 'failed at #132')

  " #133
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'cc', 'failed at #133')

  " #134
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'cc', 'failed at #134')

  " #135
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #135')

  " #136
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #136')

  " #137
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'bb(cc)bb', 'failed at #137')

  " #138
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #138')

  " #139
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #139')

  " #140
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa(bb(cc)bb)aa', 'failed at #140')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #141
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #141')

  " #142
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #142')

  " #143
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #143')

  " #144
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #144')

  " #145
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #145')

  " #146
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb', 'failed at #146')

  " #147
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'bb', 'failed at #147')

  " #148
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'bb', 'failed at #148')

  " #149
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'bb', 'failed at #149')

  " #150
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'bb', 'failed at #150')

  " #151
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb', 'failed at #151')

  " #152
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb', 'failed at #152')

  " #153
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'bb', 'failed at #153')

  " #154
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #154')

  " #155
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #155')

  " #156
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #156')

  " #157
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #157')

  " #158
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lviby
  call g:assert.equals(@@, 'aa(((bb)))aa', 'failed at #158')
endfunction
"}}}
function! s:suite.i_x_no_nest() abort "{{{
  " #159
  call setline('.', '""')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '"', 'failed at #159')

  " #160
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'a', 'failed at #160')

  " #161
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #161')

  " #162
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa', 'failed at #162')

  " #163
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa', 'failed at #163')

  " #164
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa', 'failed at #164')

  " #165
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'bb', 'failed at #165')

  " #166
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'bb', 'failed at #166')

  " #167
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'cc', 'failed at #167')

  " #168
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'cc', 'failed at #168')

  " #169
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'cc', 'failed at #169')

  " #170
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'cc', 'failed at #170')

  " #171
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'bb', 'failed at #171')

  " #172
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'bb', 'failed at #172')

  " #173
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'aa', 'failed at #173')

  " #174
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'aa', 'failed at #174')

  " #175
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'aa', 'failed at #175')

  " #176
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'aa', 'failed at #176')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #177
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #177')

  " #178
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lviby
  call g:assert.equals(@@, 'aa', 'failed at #178')

  " #179
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lviby
  call g:assert.equals(@@, 'aa', 'failed at #179')

  " #180
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lviby
  call g:assert.equals(@@, 'aa', 'failed at #180')

  " #181
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lviby
  call g:assert.equals(@@, 'aa', 'failed at #181')

  " #182
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lviby
  call g:assert.equals(@@, 'aa', 'failed at #182')

  " #183
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lviby
  call g:assert.equals(@@, 'aa', 'failed at #183')

  " #184
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lviby
  call g:assert.equals(@@, 'aa', 'failed at #184')

  " #185
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lviby
  call g:assert.equals(@@, 'bb', 'failed at #185')

  " #186
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lviby
  call g:assert.equals(@@, 'bb', 'failed at #186')

  " #187
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lviby
  call g:assert.equals(@@, 'cc', 'failed at #187')

  " #188
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lviby
  call g:assert.equals(@@, 'cc', 'failed at #188')

  " #189
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lviby
  call g:assert.equals(@@, 'cc', 'failed at #189')

  " #190
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lviby
  call g:assert.equals(@@, 'cc', 'failed at #190')

  " #191
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lviby
  call g:assert.equals(@@, 'cc', 'failed at #191')

  " #192
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lviby
  call g:assert.equals(@@, 'cc', 'failed at #192')

  " #193
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lviby
  call g:assert.equals(@@, 'cc', 'failed at #193')

  " #194
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lviby
  call g:assert.equals(@@, 'cc', 'failed at #194')
endfunction
"}}}
function! s:suite.i_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #195
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'bb', 'failed at #195')
endfunction
"}}}
function! s:suite.i_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}]

  " #196
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'b"c', 'failed at #196')

  " #197
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbviby
  call g:assert.equals(@@, 'aa(b', 'failed at #197')
endfunction
"}}}
function! s:suite.i_x_selected_area_extending() abort  "{{{
  " #198
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcviby
  call g:assert.equals(@@, 'cc', 'failed at #198')

  " #199
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvibiby
  call g:assert.equals(@@, 'bb{cc}bb', 'failed at #199')

  " #200
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvibibiby
  call g:assert.equals(@@, 'aa[bb{cc}bb]aa', 'failed at #200')
endfunction
"}}}
function! s:suite.i_x_blockwise_visual() abort  "{{{
  " #201
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>iby"
  call g:assert.equals(@@, " \na\n ", 'failed at #201')

  %delete

  " #202
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jiby"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #202')

  %delete

  " #203
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joiby"
  call g:assert.equals(@@, "aa\nbb\ncc", 'failed at #203')

  %delete

  " #204
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jiby"
  call g:assert.equals(@@, "aa)\nbb)\nccc", 'failed at #204')

  %delete

  " #205
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joiby"
  call g:assert.equals(@@, "aaa\nbb)\ncc)", 'failed at #205')
endfunction
"}}}
function! s:suite.i_x_option_eval() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #206
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #206')

  " #207
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '2', 'failed at #207')

  """ on
  call textobj#sandwich#set('auto', 'eval', 1)
  " #208
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '1', 'failed at #208')

  " #209
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #209')
endfunction
"}}}
function! s:suite.i_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #210
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #210')

  " #211
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '8', 'failed at #211')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #212
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '\', 'failed at #212')

  " #213
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #213')
endfunction
"}}}
function! s:suite.i_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #214
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #214')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #215
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'fooa', 'failed at #215')
endfunction
"}}}
function! s:suite.i_x_option_quoteescape() abort  "{{{
  " #216
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa\"bb', 'failed at #216')
endfunction
"}}}
function! s:suite.i_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #217
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #217')

  %delete

  " #218
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\naa\n", 'failed at #218')

  %delete

  " #219
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\naa\nbb\ncc\n", 'failed at #219')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #220
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #220')

  %delete

  " #221
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #221')

  %delete

  " #222
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #222')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #223
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'aa', 'failed at #223')

  %delete

  " #224
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjviby
  call g:assert.equals(@@, "\naa\n", 'failed at #224')

  %delete

  " #225
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, '"', 'failed at #225')
endfunction
"}}}
function! s:suite.i_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #226
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #226')

  " #227
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #227')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #228
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #228')

  " #229
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '{', 'failed at #229')

endfunction
"}}}
function! s:suite.i_x_option_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #230
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #230')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #231
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #231')

  highlight link TestParen Special

  " #232
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #232')
endfunction
"}}}
function! s:suite.i_x_option_match_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 1
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #233
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #233')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #234
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #234')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #235
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #235')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #236
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #236')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #237
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, '(', 'failed at #237')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #238
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0viby
  call g:assert.equals(@@, 'foo', 'failed at #238')
endfunction
"}}}
function! s:suite.i_o_option_skip_breaking() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 0
  " #239
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "\nfoo\n", 'failed at #239')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'skip_break', 1)
  " #240
  call append(0, ['(', 'foo', ')'])
  let @@ = 'fail'
  normal ggviby
  call g:assert.equals(@@, "foo", 'failed at #240')
endfunction
"}}}

function! s:suite.a_o_default_recipes() abort "{{{
  " #241
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(foo)', 'failed at #241')

  " #242
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '[foo]', 'failed at #242')

  " #243
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '{foo}', 'failed at #243')

  " #244
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '<foo>', 'failed at #244')

  " #245
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"foo"', 'failed at #245')

  " #246
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, "'foo'", 'failed at #246')
endfunction
"}}}
function! s:suite.a_o_nest() abort  "{{{
  " #247
  call setline('.', '()')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '()', 'failed at #247')

  " #248
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(a)', 'failed at #248')

  " #249
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #249')

  " #250
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #250')

  " #251
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #251')

  " #252
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #252')

  " #253
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #253')

  " #254
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #254')

  " #255
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '(cc)', 'failed at #255')

  " #256
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '(cc)', 'failed at #256')

  " #257
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '(cc)', 'failed at #257')

  " #258
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '(cc)', 'failed at #258')

  " #259
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #259')

  " #260
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #260')

  " #261
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #261')

  " #262
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #262')

  " #263
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #263')

  " #264
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #264')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #265
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #265')

  " #266
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #266')

  " #267
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #267')

  " #268
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #268')

  " #269
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #269')

  " #270
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #270')

  " #271
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #271')

  " #272
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #272')

  " #273
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #273')

  " #274
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #274')

  " #275
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #275')

  " #276
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #276')

  " #277
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '(((bb)))', 'failed at #277')

  " #278
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #278')

  " #279
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #279')

  " #280
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #280')

  " #281
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #281')

  " #282
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lyab
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #282')
endfunction
"}}}
function! s:suite.a_o_no_nest() abort "{{{
  " #283
  call setline('.', '""')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '""', 'failed at #283')

  " #284
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"a"', 'failed at #284')

  " #285
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #285')

  " #286
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '"aa"', 'failed at #286')

  " #287
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"aa"', 'failed at #287')

  " #288
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '"aa"', 'failed at #288')

  " #289
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '"bb"', 'failed at #289')

  " #290
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '"bb"', 'failed at #290')

  " #291
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '"cc"', 'failed at #291')

  " #292
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '"cc"', 'failed at #292')

  " #293
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '"cc"', 'failed at #293')

  " #294
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '"cc"', 'failed at #294')

  " #295
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '"bb"', 'failed at #295')

  " #296
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '"bb"', 'failed at #296')

  " #297
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '"aa"', 'failed at #297')

  " #298
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '"aa"', 'failed at #298')

  " #299
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '"aa"', 'failed at #299')

  " #300
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '"aa"', 'failed at #300')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #301
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"""aa"""', 'failed at #301')

  " #302
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #302')

  " #303
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #303')

  " #304
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #304')

  " #305
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #305')

  " #306
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #306')

  " #307
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #307')

  " #308
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lyab
  call g:assert.equals(@@, '"""aa"""', 'failed at #308')

  " #309
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lyab
  call g:assert.equals(@@, '"""bb"""', 'failed at #309')

  " #310
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lyab
  call g:assert.equals(@@, '"""bb"""', 'failed at #310')

  " #311
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #311')

  " #312
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #312')

  " #313
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #313')

  " #314
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #314')

  " #315
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #315')

  " #316
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #316')

  " #317
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #317')

  " #318
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lyab
  call g:assert.equals(@@, '"""cc"""', 'failed at #318')
endfunction
"}}}
function! s:suite.a_o_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = [{'external': ['it', 'at']}]

  " #319
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #319')
endfunction
"}}}
function! s:suite.a_o_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(((', ')))']}, {'buns': ['(', ')']}]

  " #320
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '(b"c)', 'failed at #320')

  " #321
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbyab
  call g:assert.equals(@@, '"aa(b"', 'failed at #321')

  " #322
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '(foo)', 'failed at #322')

  " #323
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffyab
  call g:assert.equals(@@, '(((foo)))', 'failed at #323')
endfunction
"}}}
function! s:suite.a_o_option_eval() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #324
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #324')

  " #325
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #325')

  """ on
  call textobj#sandwich#set('auto', 'eval', 1)
  " #326
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #326')

  " #327
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '2aa3', 'failed at #327')
endfunction
"}}}
function! s:suite.a_o_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #328
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #328')

  " #329
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #329')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #330
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #330')

  " #331
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '888aa888', 'failed at #331')
endfunction
"}}}
function! s:suite.a_o_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #332
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, 'afooa', 'failed at #332')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #333
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, 'afooaa', 'failed at #333')
endfunction
"}}}
function! s:suite.a_o_option_quoteescape() abort  "{{{
  " #334
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #334')
endfunction
"}}}
function! s:suite.a_o_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #335
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #335')

  %delete

  " #336
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #336')

  %delete

  " #337
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #337')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #338
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #338')

  %delete

  " #339
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #339')

  %delete

  " #340
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #340')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #341
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '"aa"', 'failed at #341')

  %delete

  " #342
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjyab
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #342')

  %delete

  " #343
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggyab
  call g:assert.equals(@@, '', 'failed at #343')
endfunction
"}}}
function! s:suite.a_o_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #344
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #344')

  " #345
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '{foo}', 'failed at #345')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #346
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #346')

  " #347
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #347')
endfunction
"}}}
function! s:suite.a_o_option_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #348
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #348')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #349
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #349')

  highlight link TestParen Special

  " #350
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #350')
endfunction
"}}}
function! s:suite.a_o_option_match_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 1
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #351
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #351')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #352
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #352')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #353
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #353')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #354
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #354')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #355
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '', 'failed at #355')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #356
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0yab
  call g:assert.equals(@@, '(foo)', 'failed at #356')
endfunction
"}}}
function! s:suite.a_o_option_synchro() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('auto', 'synchro', 1)
  nmap sd <Plug>(operator-sandwich-delete)

  " #357
  call setline('.', 'afooa')
  normal 0sdab
  call g:assert.equals(getline('.'), 'foo', 'failed at #357')
endfunction
"}}}

function! s:suite.a_x_default_recipes() abort "{{{
  " #358
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(foo)', 'failed at #358')

  " #359
  call setline('.', '[foo]')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '[foo]', 'failed at #359')

  " #360
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '{foo}', 'failed at #360')

  " #361
  call setline('.', '<foo>')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '<foo>', 'failed at #361')

  " #362
  call setline('.', '"foo"')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"foo"', 'failed at #362')

  " #363
  call setline('.', "'foo'")
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, "'foo'", 'failed at #363')
endfunction
"}}}
function! s:suite.a_x_nest() abort  "{{{
  " #364
  call setline('.', '()')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '()', 'failed at #364')

  " #365
  call setline('.', '(a)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(a)', 'failed at #365')

  " #366
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #366')

  " #367
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #367')

  " #368
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #368')

  " #369
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #369')

  " #370
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #370')

  " #371
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #371')

  " #372
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #372')

  " #373
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #373')

  " #374
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #374')

  " #375
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '(cc)', 'failed at #375')

  " #376
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #376')

  " #377
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #377')

  " #378
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '(bb(cc)bb)', 'failed at #378')

  " #379
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #379')

  " #380
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #380')

  " #381
  call setline('.', '(aa(bb(cc)bb)aa)')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '(aa(bb(cc)bb)aa)', 'failed at #381')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(((', ')))'], 'nesting': 1}]

  " #382
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #382')

  " #383
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #383')

  " #384
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #384')

  " #385
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #385')

  " #386
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #386')

  " #387
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #387')

  " #388
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #388')

  " #389
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #389')

  " #390
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #390')

  " #391
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #391')

  " #392
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #392')

  " #393
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #393')

  " #394
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '(((bb)))', 'failed at #394')

  " #395
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #395')

  " #396
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #396')

  " #397
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #397')

  " #398
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 016lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #398')

  " #399
  call setline('.', '(((aa(((bb)))aa)))')
  let @@ = 'fail'
  normal 017lvaby
  call g:assert.equals(@@, '(((aa(((bb)))aa)))', 'failed at #399')
endfunction
"}}}
function! s:suite.a_x_no_nest() abort "{{{
  " #400
  call setline('.', '""')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '""', 'failed at #400')

  " #401
  call setline('.', '"a"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"a"', 'failed at #401')

  " #402
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #402')

  " #403
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #403')

  " #404
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #404')

  " #405
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #405')

  " #406
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #406')

  " #407
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #407')

  " #408
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #408')

  " #409
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #409')

  " #410
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #410')

  " #411
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '"cc"', 'failed at #411')

  " #412
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #412')

  " #413
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '"bb"', 'failed at #413')

  " #414
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #414')

  " #415
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #415')

  " #416
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #416')

  " #417
  call setline('.', '"aa"bb"cc"bb"aa"')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '"aa"', 'failed at #417')

  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"""', '"""'], 'nesting': 0}]

  " #418
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #418')

  " #419
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 0lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #419')

  " #420
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 02lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #420')

  " #421
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 03lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #421')

  " #422
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 04lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #422')

  " #423
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 05lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #423')

  " #424
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 06lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #424')

  " #425
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 07lvaby
  call g:assert.equals(@@, '"""aa"""', 'failed at #425')

  " #426
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 08lvaby
  call g:assert.equals(@@, '"""bb"""', 'failed at #426')

  " #427
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 09lvaby
  call g:assert.equals(@@, '"""bb"""', 'failed at #427')

  " #428
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 010lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #428')

  " #429
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 011lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #429')

  " #430
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 012lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #430')

  " #431
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 013lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #431')

  " #432
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 014lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #432')

  " #433
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 015lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #433')

  " #434
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 016lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #434')

  " #435
  call setline('.', '"""aa"""bb"""cc"""')
  let @@ = 'fail'
  normal 017lvaby
  call g:assert.equals(@@, '"""cc"""', 'failed at #435')
endfunction
"}}}
function! s:suite.a_x_external_textobj() abort  "{{{
  let g:textobj#sandwich#recipes = []

  " #436
  call setline('.', 'aa<title>bb</title>aa')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '<title>bb</title>', 'failed at #436')
endfunction
"}}}
function! s:suite.a_x_priority() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(((', ')))']}, {'buns': ['(', ')']}]

  " #437
  call setline('.', '"aa(b"c)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '(b"c)', 'failed at #437')

  " #438
  call setline('.', '"aa(b"ccc)')
  let @@ = 'fail'
  normal 0fbvaby
  call g:assert.equals(@@, '"aa(b"', 'failed at #438')

  " #439
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(foo)', 'failed at #439')

  " #440
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}, {'buns': ['(', ')']}, {'buns': ['(((', ')))']}]
  call setline('.', '(((foo)))')
  let @@ = 'fail'
  normal 0ffvaby
  call g:assert.equals(@@, '(((foo)))', 'failed at #440')
endfunction
"}}}
function! s:suite.a_x_selected_area_extending() abort  "{{{
  " #441
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvaby
  call g:assert.equals(@@, '{cc}', 'failed at #441')

  " #442
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvababy
  call g:assert.equals(@@, '[bb{cc}bb]', 'failed at #442')

  " #443
  call setline('.', '(aa[bb{cc}bb]aa)')
  let @@ = 'fail'
  normal 0fcvabababy
  call g:assert.equals(@@, '(aa[bb{cc}bb]aa)', 'failed at #443')
endfunction
"}}}
function! s:suite.a_x_blockwise_visual() abort  "{{{
  " #444
  call append(0, ['( ', 'aa', '  )'])
  let @@ = 'fail'
  execute "normal gg\<C-v>aby"
  call g:assert.equals(@@, "( \naa\n  )", 'failed at #444')

  %delete

  " #445
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #445')

  %delete

  " #446
  call append(0, ['(aa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(cc)", 'failed at #446')

  %delete

  " #447
  call append(0, ['(aa)', '(bb)', '(ccc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2jaby"
  call g:assert.equals(@@, "(aa)\n(bb)\n(ccc)", 'failed at #447')

  %delete

  " #448
  call append(0, ['(aaa)', '(bb)', '(cc)'])
  let @@ = 'fail'
  execute "normal gg\<C-v>2joaby"
  call g:assert.equals(@@, "(aaa)\n(bb)\n(cc)", 'failed at #448')
endfunction
"}}}
function! s:suite.a_x_option_eval() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['1+1', '1+2']}]

  """ off
  " #449
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '1+1aa1+2', 'failed at #449')

  " #450
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2', 'failed at #450')

  """ on
  call textobj#sandwich#set('auto', 'eval', 1)
  " #451
  call setline('.', '1+1aa1+2')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '1', 'failed at #451')

  " #452
  call setline('.', '2aa3')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '2aa3', 'failed at #452')
endfunction
"}}}
function! s:suite.a_x_option_regex() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['\d\+', '\d\+']}]

  """ off
  " #453
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '\d\+aa\d\+', 'failed at #453')

  " #454
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '8', 'failed at #454')

  """ on
  call textobj#sandwich#set('auto', 'regex', 1)
  " #455
  call setline('.', '\d\+aa\d\+')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '\', 'failed at #455')

  " #456
  call setline('.', '888aa888')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '888aa888', 'failed at #456')
endfunction
"}}}
function! s:suite.a_x_option_skip_regex() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]

  """ off
  " #457
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'afooa', 'failed at #457')

  """ on
  call textobj#sandwich#set('auto', 'skip_regex', ['aa'])
  " #458
  call setline('.', 'afooaa')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, 'afooaa', 'failed at #458')
endfunction
"}}}
function! s:suite.a_x_option_quoteescape() abort  "{{{
  " #459
  call setline('.', '"aa\"bb"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa\"bb"', 'failed at #459')
endfunction
"}}}
function! s:suite.a_x_option_expand_range() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['"', '"']}]

  """ -1
  " #460
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #460')

  %delete

  " #461
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #461')

  %delete

  " #462
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, "\"\naa\nbb\ncc\n\"", 'failed at #462')

  %delete

  """ 0
  call textobj#sandwich#set('auto', 'expand_range', 0)
  " #463
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #463')

  %delete

  " #464
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #464')

  %delete

  " #465
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #465')

  %delete

  """ 1
  call textobj#sandwich#set('auto', 'expand_range', 1)
  " #466
  call setline('.', '"aa"')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '"aa"', 'failed at #466')

  %delete

  " #467
  call append(0, ['"', 'aa', '"'])
  let @@ = 'fail'
  normal ggjvaby
  call g:assert.equals(@@, "\"\naa\n\"", 'failed at #467')

  %delete

  " #468
  call append(0, ['"', 'aa', 'bb', 'cc', '"'])
  let @@ = 'fail'
  normal ggvaby
  call g:assert.equals(@@, '"', 'failed at #468')
endfunction
"}}}
function! s:suite.a_x_option_noremap() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'external': ['i{', 'a{']}]
  xnoremap i{ i(
  xnoremap a{ a(

  """ on
  " #469
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #469')

  " #470
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{foo}', 'failed at #470')

  """ off
  call textobj#sandwich#set('auto', 'noremap', 0)
  " #471
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #471')

  " #472
  call setline('.', '{foo}')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '{', 'failed at #472')
endfunction
"}}}
function! s:suite.a_x_option_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]
  call textobj#sandwich#set('auto', 'syntax', [])

  " #473
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #473')

  call textobj#sandwich#set('auto', 'syntax', ['Special'])
  syn match TestParen '[()]'
  highlight link TestParen String

  " #474
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #474')

  highlight link TestParen Special

  " #475
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #475')
endfunction
"}}}
function! s:suite.a_x_option_match_syntax() abort "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['(', ')']}]

  """ 1
  call textobj#sandwich#set('auto', 'match_syntax', 1)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #476
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #476')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #477
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #477')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #478
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #478')

  """ 2
  call textobj#sandwich#set('auto', 'match_syntax', 2)
  syntax clear
  syntax match TestParen '[()]'
  highlight link TestParen Special

  " #479
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #479')

  syntax clear
  syntax match TestBra '('
  syntax match TestKet ')'
  highlight link TestBra Special
  highlight link TestKet String

  " #480
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(', 'failed at #480')

  syntax clear
  syntax match TestBra '(f'
  syntax match TestKet 'o)'
  highlight link TestBra Special
  highlight link TestKet Special

  " #481
  call setline('.', '(foo)')
  let @@ = 'fail'
  normal 0vaby
  call g:assert.equals(@@, '(foo)', 'failed at #481')
endfunction
"}}}
function! s:suite.a_x_option_synchro() abort  "{{{
  let g:sandwich#recipes = []
  let g:textobj#sandwich#recipes = [{'buns': ['a', 'a']}]
  let g:operator#sandwich#recipes = []
  call textobj#sandwich#set('auto', 'synchro', 1)
  xmap sd <Plug>(operator-sandwich-delete)

  " #482
  call setline('.', 'afooa')
  normal 0vabsd
  call g:assert.equals(getline('.'), 'foo', 'failed at #482')
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
