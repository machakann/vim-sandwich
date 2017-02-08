function! sandwich#util#echo(messages) abort  "{{{
  echo ''
  for [mes, hi_group] in a:messages
    execute 'echohl ' . hi_group
    echon mes
    echohl NONE
  endfor
endfunction
"}}}
function! sandwich#util#addlocal(recipes) abort "{{{
  if !exists('b:sandwich_recipes')
    let b:sandwich_recipes = deepcopy(g:sandwich#recipes)
  endif
  call extend(b:sandwich_recipes, copy(a:recipes), 0)
  return b:sandwich_recipes
endfunction
"}}}
function! sandwich#util#ftrevert(filetype) abort "{{{
  if exists('b:sandwich_recipes')
    call filter(b:sandwich_recipes, 'get(v:val, "__filetype__", "") !=# a:filetype')
  endif
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
