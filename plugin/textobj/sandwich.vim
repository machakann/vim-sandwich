" The vim textobject plugin to search and select 'sandwich' like structure
" Last Change: 30-Oct-2021.
" Maintainer : Masaaki Nakamura <mckn@outlook.jp>

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
