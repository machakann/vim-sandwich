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
  return s:extend_local(a:recipes)
endfunction
"}}}
function! sandwich#util#insertlocal(recipes) abort "{{{
  return s:extend_local(a:recipes, 0)
endfunction
"}}}
function! sandwich#util#ftrevert(filetype) abort "{{{
  if exists('b:sandwich_recipes')
    call filter(b:sandwich_recipes, 'get(v:val, "__filetype__", "") !=# a:filetype')
  endif
endfunction
"}}}


function! s:extend_local(recipes, ...) abort "{{{
  if !exists('b:sandwich_recipes')
    if exists('g:sandwich#recipes')
      let b:sandwich_recipes = deepcopy(g:sandwich#recipes)
    else
      let b:sandwich_recipes = deepcopy(g:sandwich#default_recipes)
    endif
  endif
  let i = get(a:000, 0, len(b:sandwich_recipes))
  call extend(b:sandwich_recipes, copy(a:recipes), i)
  return b:sandwich_recipes
endfunction "}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
