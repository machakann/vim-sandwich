if &compatible || exists('b:did_sandwich_initex_ftplugin') || get(g:, 'sandwich_no_initex_ftplugin', 0)
  finish
endif
scriptencoding utf-8

if !exists('b:undo_ftplugin')
  " Make sure that 'b:undo_ftplugin' exists.
  runtime ftplugin/initex.vim
endif

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
        \   {'__filetype__': 'initex', 'buns': ['\{', '\}'],  'nesting': 1, 'input': [ '\{' ], 'filetype': ['initex', 'plaintex', 'tex'], 'indentkeys-': '{,},0{,0}'},
        \   {'__filetype__': 'initex', 'buns': ['\[', '\]'],  'nesting': 1, 'input': [ '\[' ], 'filetype': ['initex', 'plaintex', 'tex'], 'indentkeys-': '{,},0{,0}'},
        \   {'__filetype__': 'initex', 'buns': ['\left(',        '\right)'],        'nesting': 1, 'input': [ 'm(' ], 'filetype': ['initex', 'plaintex', 'tex'], 'indentkeys-': '(,)'},
        \   {'__filetype__': 'initex', 'buns': ['\left[',        '\right]'],        'nesting': 1, 'input': [ 'm[' ], 'filetype': ['initex', 'plaintex', 'tex'], 'indentkeys-': '[,]'},
        \   {'__filetype__': 'initex', 'buns': ['\left|',        '\right|'],        'nesting': 1, 'input': [ 'm|' ], 'filetype': ['initex', 'plaintex', 'tex']},
        \   {'__filetype__': 'initex', 'buns': ['\left\{',       '\right\}'],       'nesting': 1, 'input': [ 'm{' ], 'filetype': ['initex', 'plaintex', 'tex'], 'indentkeys-': '{,},0{,0}'},
        \   {'__filetype__': 'initex', 'buns': ['\left\langle ', '\right\rangle '], 'nesting': 1, 'input': [ 'm<' ], 'filetype': ['initex', 'plaintex', 'tex']},
        \   {'__filetype__': 'initex', 'buns': ['\big(',         '\big)'],          'nesting': 1, 'input': [ 'M(' ], 'filetype': ['initex', 'plaintex', 'tex'], 'indentkeys-': '(,)'},
        \   {'__filetype__': 'initex', 'buns': ['\big[',         '\big]'],          'nesting': 1, 'input': [ 'M[' ], 'filetype': ['initex', 'plaintex', 'tex'], 'indentkeys-': '[,]'},
        \   {'__filetype__': 'initex', 'buns': ['\bigl|',        '\bigr|'],         'nesting': 1, 'input': [ 'M|' ], 'filetype': ['initex', 'plaintex', 'tex']},
        \   {'__filetype__': 'initex', 'buns': ['\big\{',        '\big\}'],         'nesting': 1, 'input': [ 'M{' ], 'filetype': ['initex', 'plaintex', 'tex'], 'indentkeys-': '{,},0{,0}'},
        \   {'__filetype__': 'initex', 'buns': ['\big\langle ',  '\big\rangle '],   'nesting': 1, 'input': [ 'M<' ], 'filetype': ['initex', 'plaintex', 'tex']},
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
        \     'buns'    : ['\\begin{[^}]*}\(\[.*\]\)\?', '\\end{[^}]*}'],
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
        \     'buns'    : ['\m\C\%(\%(\\left\|\\[Bb]igg\?l\?\)\%([[(|.]\|\\{\|\\langle\|\\lVert\|\\lvert\|\\lceil\|\\lfloor\)\|\\langle\|\\lVert\|\\lvert\|\\lceil\|\\lfloor\)', '\m\C\%(\%(\\right\|\\[Bb]igg\?r\?\)\%([])|.]\|\\}\|\\rangle\|\\rVert\|\\rvert\|\\rceil\|\\rfloor\)\|\\rangle\|\\rVert\|\\rvert\|\\rceil\|\\rfloor\)'],
        \     'filetype': ['initex', 'plaintex', 'tex'],
        \     'kind'    : ['delete', 'replace', 'auto', 'query'],
        \     'regex'   : 1,
        \     'nesting' : 1,
        \     'input'   : ['ma'],
        \     'indentkeys-' : '{,},0{,0}',
        \     'autoindent' : 0,
        \   },
        \ ]
endif
call sandwich#util#addlocal(s:local_recipes)

let b:did_sandwich_initex_ftplugin = 1
if !exists('b:undo_ftplugin')
  " A case that ftplugin/initex.vim is disabled
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= ' | unlet b:did_sandwich_initex_ftplugin | call sandwich#util#ftrevert("initex")'
