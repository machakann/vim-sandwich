" prepare recipes
function! sandwich#get_recipes() abort  "{{{
  if exists('b:sandwich_recipes')
    let recipes = b:sandwich_recipes
  elseif exists('g:sandwich#recipes')
    let recipes = g:sandwich#recipes
  else
    let recipes = g:sandwich#default_recipes
  endif
  return deepcopy(recipes)
endfunction
"}}}
if exists('g:sandwich#default_recipes')
  unlockvar! g:sandwich#default_recipes
endif
let g:sandwich#default_recipes = [
      \   {'buns': ['<', '>'], 'expand_range': 0, 'match_syntax': 1},
      \   {'buns': ['"', '"'], 'quoteescape': 1, 'expand_range': 0, 'nesting': 0, 'linewise': 0, 'match_syntax': 1},
      \   {'buns': ["'", "'"], 'quoteescape': 1, 'expand_range': 0, 'nesting': 0, 'linewise': 0, 'match_syntax': 1},
      \   {'buns': ['{', '}'], 'nesting': 1, 'match_syntax': 1, 'skip_break': 1},
      \   {'buns': ['[', ']'], 'nesting': 1, 'match_syntax': 1},
      \   {'buns': ['(', ')'], 'nesting': 1, 'match_syntax': 1},
      \   {'buns': 'sandwich#magicchar#t#taginput()', 'listexpr': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'filetype': ['html', 'xhtml', 'xml'], 'input': ['t']},
      \   {'external': ['it', 'at'], 'noremap' : 1, 'kind' : ['delete', 'replace', 'textobj'], 'synchro': 1, 'input': ['t']},
      \   {'buns': ['sandwich#magicchar#f#fname()', '")"'], 'kind': ['add', 'replace'], 'action': ['add'], 'expr': 1, 'cursor': 'inner_tail', 'input': ['f']},
      \   {'external': ["\<Plug>(textobj-sandwich-function-i)", "\<Plug>(textobj-sandwich-function-a)"], 'noremap': 0, 'kind': ['delete', 'replace', 'query'], 'input': ['f']},
      \ ]
lockvar! g:sandwich#default_recipes

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
