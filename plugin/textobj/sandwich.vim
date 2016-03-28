" The vim textobject plugin to search and select 'sandwich' like structure
" Last Change: 28-Mar-2016.
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

omap ib <Plug>(textobj-sandwich-auto-i)
xmap ib <Plug>(textobj-sandwich-auto-i)
omap ab <Plug>(textobj-sandwich-auto-a)
xmap ab <Plug>(textobj-sandwich-auto-a)

omap is <Plug>(textobj-sandwich-query-i)
xmap is <Plug>(textobj-sandwich-query-i)
omap as <Plug>(textobj-sandwich-query-a)
xmap as <Plug>(textobj-sandwich-query-a)

