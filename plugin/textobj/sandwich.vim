" The vim textobject plugin to search and select 'sandwich' like structure
" Last Change: 16-Sep-2016.
" Maintainer : Masaaki Nakamura <mckn@outlook.com>

" License    : NYSL
"              Japanese <http://www.kmonos.net/nysl/>
"              English (Unofficial) <http://www.kmonos.net/nysl/index.en.html>

if exists("g:loaded_textobj_sandwich")
  finish
endif
let g:loaded_textobj_sandwich = 1

nnoremap <silent><expr> <Plug>(textobj-sandwich-auto-i) textobj#sandwich#auto('n', 'i')
onoremap <silent><expr> <Plug>(textobj-sandwich-auto-i) textobj#sandwich#auto('o', 'i')
xnoremap <silent><expr> <Plug>(textobj-sandwich-auto-i) textobj#sandwich#auto('x', 'i')
nnoremap <silent><expr> <Plug>(textobj-sandwich-auto-a) textobj#sandwich#auto('n', 'a')
onoremap <silent><expr> <Plug>(textobj-sandwich-auto-a) textobj#sandwich#auto('o', 'a')
xnoremap <silent><expr> <Plug>(textobj-sandwich-auto-a) textobj#sandwich#auto('x', 'a')

nnoremap <silent><expr> <Plug>(textobj-sandwich-query-i) textobj#sandwich#query('n', 'i')
onoremap <silent><expr> <Plug>(textobj-sandwich-query-i) textobj#sandwich#query('o', 'i')
xnoremap <silent><expr> <Plug>(textobj-sandwich-query-i) textobj#sandwich#query('x', 'i')
nnoremap <silent><expr> <Plug>(textobj-sandwich-query-a) textobj#sandwich#query('n', 'a')
onoremap <silent><expr> <Plug>(textobj-sandwich-query-a) textobj#sandwich#query('o', 'a')
xnoremap <silent><expr> <Plug>(textobj-sandwich-query-a) textobj#sandwich#query('x', 'a')

nnoremap <silent><expr> <Plug>(textobj-sandwich-literal-query-i) textobj#sandwich#query('n', 'i', {}, [])
onoremap <silent><expr> <Plug>(textobj-sandwich-literal-query-i) textobj#sandwich#query('o', 'i', {}, [])
xnoremap <silent><expr> <Plug>(textobj-sandwich-literal-query-i) textobj#sandwich#query('x', 'i', {}, [])
nnoremap <silent><expr> <Plug>(textobj-sandwich-literal-query-a) textobj#sandwich#query('n', 'a', {}, [])
onoremap <silent><expr> <Plug>(textobj-sandwich-literal-query-a) textobj#sandwich#query('o', 'a', {}, [])
xnoremap <silent><expr> <Plug>(textobj-sandwich-literal-query-a) textobj#sandwich#query('x', 'a', {}, [])

" intrinsic keymappings
noremap <Plug>(sandwich-nop) <Nop>

""" default keymappings
" If g:textobj_sandwich_no_default_key_mappings has been defined, then quit immediately.
if exists('g:textobj_sandwich_no_default_key_mappings') | finish | endif

silent! omap <unique> ib <Plug>(textobj-sandwich-auto-i)
silent! xmap <unique> ib <Plug>(textobj-sandwich-auto-i)
silent! omap <unique> ab <Plug>(textobj-sandwich-auto-a)
silent! xmap <unique> ab <Plug>(textobj-sandwich-auto-a)

silent! omap <unique> is <Plug>(textobj-sandwich-query-i)
silent! xmap <unique> is <Plug>(textobj-sandwich-query-i)
silent! omap <unique> as <Plug>(textobj-sandwich-query-a)
silent! xmap <unique> as <Plug>(textobj-sandwich-query-a)

