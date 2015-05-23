" prepare recipes
function! sandwich#get_recipes() abort  "{{{
  let default = exists('g:sandwich#no_default_recipes')
            \ ? [] : g:sandwich#default_recipes
  return deepcopy(get(g:, 'sandwich#recipes', default))
endfunction
"}}}
if exists('g:sandwich#default_recipes')
  unlockvar! g:sandwich#default_recipes
endif
let g:sandwich#default_recipes = [
      \   {'buns': ['<', '>'], 'expand_range': 0, 'match_syntax': 1},
      \   {'external': ['it', 'at'], 'input': ['t']},
      \   {'buns': ['"', '"'], 'quoteescape': 1, 'expand_range': 0, 'nesting': 0, 'match_syntax': 2},
      \   {'buns': ["'", "'"], 'quoteescape': 1, 'expand_range': 0, 'nesting': 0, 'match_syntax': 2},
      \   {'buns': ['{', '}'], 'nesting': 1, 'match_syntax': 1, 'skip_break': 1},
      \   {'buns': ['[', ']'], 'nesting': 1, 'match_syntax': 1},
      \   {'buns': ['(', ')'], 'nesting': 1, 'match_syntax': 1},
      \ ]
lockvar! g:sandwich#default_recipes

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
