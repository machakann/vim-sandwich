if &compatible || exists('b:did_sandwich_initex_ftplugin') || get(g:, 'sandwich_no_initex_ftplugin', 0)
  finish
endif
scriptencoding utf-8

if !exists('s:local_recipes')
  let s:local_recipes = [
        \   {'__filetype__': 'initex', 'buns': ['“', '”'],    'nesting': 1, 'input': [ 'u"' ], 'filetype': ['initex', 'plaintex', 'tex']},
        \   {'__filetype__': 'initex', 'buns': ['„', '“'],    'nesting': 1, 'input': [ 'U"', 'ug', 'u,' ], 'filetype': ['initex', 'plaintex', 'tex']},
        \   {'__filetype__': 'initex', 'buns': ['«', '»'],    'nesting': 1, 'input': [ 'u<', 'uf' ], 'filetype': ['initex', 'plaintex', 'tex']},
        \   {'__filetype__': 'initex', 'buns': ["`", "'"],    'nesting': 1, 'input': [ "l'", "l`" ], 'filetype': ['initex', 'plaintex', 'tex']},
        \   {'__filetype__': 'initex', 'buns': ["``", "''"],  'nesting': 1, 'input': [ 'l"' ], 'filetype': ['initex', 'plaintex', 'tex']},
        \   {'__filetype__': 'initex', 'buns': ['"`', "\"'"], 'nesting': 1, 'input': [ 'L"' ], 'filetype': ['initex', 'plaintex', 'tex']},
        \   {'__filetype__': 'initex', 'buns': [",,", "``"],  'nesting': 1, 'input': [ 'l,' ], 'filetype': ['initex', 'plaintex', 'tex']},
        \   {'__filetype__': 'initex', 'buns': ['<<', '>>'],  'nesting': 1, 'input': [ 'l<' ], 'filetype': ['initex', 'plaintex', 'tex']},
        \   {'__filetype__': 'initex', 'buns': ['$', '$'],    'nesting': 0, 'filetype': ['initex', 'plaintex', 'tex']},
        \   {'__filetype__': 'initex', 'buns': ['\(', '\)'],  'nesting': 1, 'input': [ '\(' ], 'filetype': ['initex', 'plaintex', 'tex'], 'indentkeys-': '{,},0{,0}'},
        \   {'__filetype__': 'initex', 'buns': ['\{', '\}'],  'nesting': 1, 'input': [ '\{' ], 'filetype': ['initex', 'plaintex', 'tex'], 'indentkeys-': '{,},0{,0}'},
        \   {'__filetype__': 'initex', 'buns': ['\[', '\]'],  'nesting': 1, 'input': [ '\[' ], 'filetype': ['initex', 'plaintex', 'tex'], 'indentkeys-': '{,},0{,0}'},
        \   {'__filetype__': 'initex', 'buns': ['\left(',        '\right)'],        'nesting': 1, 'input': [ 'm(' ], 'filetype': ['initex', 'plaintex', 'tex'], 'kind': ['add', 'replace'], 'action': ['add'], 'indentkeys-': '(,)'},
        \   {'__filetype__': 'initex', 'buns': ['\left[',        '\right]'],        'nesting': 1, 'input': [ 'm[' ], 'filetype': ['initex', 'plaintex', 'tex'], 'kind': ['add', 'replace'], 'action': ['add'], 'indentkeys-': '[,]'},
        \   {'__filetype__': 'initex', 'buns': ['\left|',        '\right|'],        'nesting': 1, 'input': [ 'm|' ], 'filetype': ['initex', 'plaintex', 'tex'], 'kind': ['add', 'replace'], 'action': ['add']},
        \   {'__filetype__': 'initex', 'buns': ['\left\{',       '\right\}'],       'nesting': 1, 'input': [ 'm{' ], 'filetype': ['initex', 'plaintex', 'tex'], 'kind': ['add', 'replace'], 'action': ['add'], 'indentkeys-': '{,},0{,0}'},
        \   {'__filetype__': 'initex', 'buns': ['\left\langle ', '\right\rangle '], 'nesting': 1, 'input': [ 'm<' ], 'filetype': ['initex', 'plaintex', 'tex'], 'kind': ['add', 'replace'], 'action': ['add']},
        \   {'__filetype__': 'initex', 'buns': ['\big(',         '\big)'],          'nesting': 1, 'input': [ 'M(' ], 'filetype': ['initex', 'plaintex', 'tex'], 'kind': ['add', 'replace'], 'action': ['add'], 'indentkeys-': '(,)'},
        \   {'__filetype__': 'initex', 'buns': ['\big[',         '\big]'],          'nesting': 1, 'input': [ 'M[' ], 'filetype': ['initex', 'plaintex', 'tex'], 'kind': ['add', 'replace'], 'action': ['add'], 'indentkeys-': '[,]'},
        \   {'__filetype__': 'initex', 'buns': ['\bigl|',        '\bigr|'],         'nesting': 1, 'input': [ 'M|' ], 'filetype': ['initex', 'plaintex', 'tex'], 'kind': ['add', 'replace'], 'action': ['add']},
        \   {'__filetype__': 'initex', 'buns': ['\big\{',        '\big\}'],         'nesting': 1, 'input': [ 'M{' ], 'filetype': ['initex', 'plaintex', 'tex'], 'kind': ['add', 'replace'], 'action': ['add'], 'indentkeys-': '{,},0{,0}'},
        \   {'__filetype__': 'initex', 'buns': ['\big\langle ',  '\big\rangle '],   'nesting': 1, 'input': [ 'M<' ], 'filetype': ['initex', 'plaintex', 'tex'], 'kind': ['add', 'replace'], 'action': ['add']},
        \   {
        \     '__filetype__': 'initex',
        \     'buns'    : ['\begingroup', '\endgroup'],
        \     'nesting' : 1,
        \     'input': ['gr', '\gr'],
        \     'filetype': ['initex', 'plaintex', 'tex'],
        \     'linewise': 1,
        \   },
        \   {
        \     '__filetype__': 'initex',
        \     'buns'    : ['\toprule', '\bottomrule'],
        \     'nesting' : 1,
        \     'input': ['tr', '\tr', 'br', '\br'],
        \     'filetype': ['initex', 'plaintex', 'tex'],
        \     'linewise': 1,
        \   },
        \   {
        \     '__filetype__': 'initex',
        \     'buns'    : 'sandwich#filetype#tex#CmdInput()',
        \     'filetype': ['initex', 'plaintex', 'tex'],
        \     'kind'    : ['add', 'replace'],
        \     'action'  : ['add'],
        \     'listexpr': 1,
        \     'nesting' : 1,
        \     'input'   : ['c'],
        \     'indentkeys-' : '{,},0{,0}',
        \   },
        \   {
        \     '__filetype__': 'initex',
        \     'buns'    : 'sandwich#filetype#tex#EnvInput()',
        \     'filetype': ['initex', 'plaintex', 'tex'],
        \     'kind'    : ['add', 'replace'],
        \     'action'  : ['add'],
        \     'listexpr': 1,
        \     'nesting' : 1,
        \     'linewise' : 1,
        \     'input'   : ['e'],
        \     'indentkeys-' : '{,},0{,0}',
        \     'autoindent' : 0,
        \   },
        \   {
        \     '__filetype__': 'initex',
        \     'buns'    : ['\\\a\+\*\?{', '}'],
        \     'filetype': ['initex', 'plaintex', 'tex'],
        \     'kind'    : ['delete', 'replace', 'auto', 'query'],
        \     'regex'   : 1,
        \     'nesting' : 1,
        \     'input'   : ['c'],
        \     'indentkeys-' : '{,},0{,0}',
        \   },
        \   {
        \     '__filetype__': 'initex',
        \     'buns'    : ['\\begin{[^}]*}\%(\[.*\]\)\?', '\\end{[^}]*}'],
        \     'filetype': ['initex', 'plaintex', 'tex'],
        \     'kind'    : ['delete', 'replace', 'auto', 'query'],
        \     'regex'   : 1,
        \     'nesting' : 1,
        \     'linewise' : 1,
        \     'input'   : ['e'],
        \     'indentkeys-' : '{,},0{,0}',
        \     'autoindent' : 0,
        \   },
        \   {
        \     '__filetype__': 'initex',
        \     'external': ["\<Plug>(textobj-sandwich-filetype-tex-marks-i)", "\<Plug>(textobj-sandwich-filetype-tex-marks-a)"],
        \     'filetype': ['initex', 'plaintex', 'tex'],
        \     'kind'    : ['delete', 'replace', 'auto', 'query'],
        \     'noremap' : 0,
        \     'input'   : ['ma'],
        \     'indentkeys': '{,},0{,0}',
        \     'autoindent': 0,
        \   },
        \ ]

  xnoremap <silent><expr> <Plug>(textobj-sandwich-filetype-tex-marks-i) textobj#sandwich#auto('x', 'i', {'synchro': 0}, b:sandwich_tex_marks_recipes)
  xnoremap <silent><expr> <Plug>(textobj-sandwich-filetype-tex-marks-a) textobj#sandwich#auto('x', 'a', {'synchro': 0}, b:sandwich_tex_marks_recipes)
  let s:marks_recipes = []
  let s:marks_recipes += [
        \   {
        \     'buns': ['\%([[(]\|\\{\)', '\%([])]\|\\}\)'],
        \     'regex': 1,
        \     'nesting': 1,
        \   },
        \   {
        \     'buns': ['|', '|'],
        \     'nesting': 0,
        \   },
        \   {
        \     'buns': ['\m\C\\[Bb]igg\?l|', '\m\C\\[Bb]igg\?r|'],
        \     'regex': 1,
        \     'nesting': 1,
        \   },
        \   {
        \     'buns': ['\m\C\\\%(langle\|lVert\|lvert\|lceil\|lfloor\)', '\m\C\\\%(rangle\|rVert\|rvert\|rceil\|rfloor\)'],
        \     'regex': 1,
        \     'nesting': 1,
        \   },
        \   {
        \     'buns': ['\m\C\\left\%([[(|.]\|\\{\|\\langle\|\\lVert\|\\lvert\|\\lceil\|\\lfloor\)', '\m\C\\right\%([])|.]\|\\}\|\\rangle\|\\rVert\|\\rvert\|\\rceil\|\\rfloor\)'],
        \     'regex': 1,
        \     'nesting': 1,
        \   },
        \ ]
  " NOTE: It is not reasonable to set 'nesting' on when former and latter surrounds are same.
  let s:marks_recipes += [
        \   {
        \     'buns': ['\m\C\\[Bb]igg\?|', '\m\C\\[Bb]igg\?|'],
        \     'regex': 1,
        \     'nesting': 0,
        \   },
        \ ]
  " NOTE: The existence of '\big.' makes the situation tricky.
  "       Try to search those two cases independently and adopt the nearest item.
  "         \big. foo \big)
  "         \big( foo \big.
  "       This roundabout enables the following:
  "         \big( foo \big. bar \big. baz \big)
  "       When the cursor is on;
  "         foo -> \big( and \big.
  "         bar -> nothing
  "         foo -> \big. and \big)
  "       were deleted by the input 'sdma'.
  let s:marks_recipes += [
        \   {
        \     'buns': ['\m\C\\[Bb]igg\?l\?\%([[(]\|\\{\|\\langle\|\\lVert\|\\lvert\|\\lceil\|\\lfloor\)', '\m\C\\[Bb]igg\?r\?\%([]).]\|\\}\|\\rangle\|\\rVert\|\\rvert\|\\rceil\|\\rfloor\)'],
        \     'regex': 1,
        \     'nesting': 1,
        \   },
        \   {
        \     'buns': ['\m\C\\[Bb]igg\?l\?\%([[(.]\|\\{\|\\langle\|\\lVert\|\\lvert\|\\lceil\|\\lfloor\)', '\m\C\\[Bb]igg\?r\?\%([])]\|\\}\|\\rangle\|\\rVert\|\\rvert\|\\rceil\|\\rfloor\)'],
        \     'regex': 1,
        \     'nesting': 1,
        \   },
        \   {
        \     'buns': ['\m\C\\[Bb]igg\?|', '\m\C\\[Bb]igg\?.'],
        \     'regex': 1,
        \     'nesting': 0,
        \   },
        \   {
        \     'buns': ['\m\C\\[Bb]igg\?.', '\m\C\\[Bb]igg\?|'],
        \     'regex': 1,
        \     'nesting': 0,
        \   },
        \   {
        \     'buns': ['\m\C\\[Bb]igg\?l|', '\m\C\\[Bb]igg\?r[|.]'],
        \     'regex': 1,
        \     'nesting': 1,
        \   },
        \   {
        \     'buns': ['\m\C\\[Bb]igg\?l[|.]', '\m\C\\[Bb]igg\?r|'],
        \     'regex': 1,
        \     'nesting': 1,
        \   },
        \ ]
endif
call sandwich#util#addlocal(s:local_recipes)
let b:sandwich_tex_marks_recipes = deepcopy(s:marks_recipes)

let b:did_sandwich_initex_ftplugin = 1
if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
else
  let b:undo_ftplugin .= ' | '
endif
let b:undo_ftplugin .= 'unlet b:did_sandwich_initex_ftplugin | call sandwich#util#ftrevert("initex")'
