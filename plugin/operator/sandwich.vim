" The vim operator plugin to do well with 'sandwich' like structure
" Last Change: 23-May-2015.
" Maintainer : Masaaki Nakamura <mckn@outlook.jp>

" License    : NYSL
"              Japanese <http://www.kmonos.net/nysl/>
"              English (Unofficial) <http://www.kmonos.net/nysl/index.en.html>

if &compatible || exists("g:loaded_operator_sandwich")
  finish
endif
let g:loaded_operator_sandwich = 1

" keymappings
nnoremap <silent> <Plug>(operator-sandwich-add)     <Esc>:call operator#sandwich#prerequisite('add', 'n')<CR>g@
xnoremap <silent> <Plug>(operator-sandwich-add)     <Esc>:call operator#sandwich#prerequisite('add', 'x')<CR>gvg@
nnoremap <silent> <Plug>(operator-sandwich-delete)  <Esc>:call operator#sandwich#prerequisite('delete', 'n')<CR>g@
xnoremap <silent> <Plug>(operator-sandwich-delete)  <Esc>:call operator#sandwich#prerequisite('delete', 'x')<CR>gvg@
nnoremap <silent> <Plug>(operator-sandwich-replace) <Esc>:call operator#sandwich#prerequisite('replace', 'n')<CR>g@
xnoremap <silent> <Plug>(operator-sandwich-replace) <Esc>:call operator#sandwich#prerequisite('replace', 'x')<CR>gvg@

nnoremap <silent> <Plug>(operator-sandwich-add-query1st)     <Esc>:call operator#sandwich#query1st('add', 'n')<CR>
xnoremap <silent> <Plug>(operator-sandwich-add-query1st)     <Esc>:call operator#sandwich#query1st('add', 'x')<CR>
nnoremap <silent> <Plug>(operator-sandwich-replace-query1st) <Esc>:call operator#sandwich#query1st('replace', 'n')<CR>
xnoremap <silent> <Plug>(operator-sandwich-replace-query1st) <Esc>:call operator#sandwich#query1st('replace', 'x')<CR>

" supplementary keymappings
onoremap <expr><silent> <Plug>(operator-sandwich-synchro-count) operator#sandwich#synchro_count()
onoremap <expr><silent> <Plug>(operator-sandwich-release-count) operator#sandwich#release_count()

" intrinsic keymappings
nnoremap <Plug>(sandwich-i) i
nnoremap <Plug>(sandwich-o) o
nnoremap <Plug>(sandwich-O) O
nnoremap <Plug>(sandwich-v) v
nnoremap <Plug>(sandwich-V) V
nnoremap <Plug>(sandwich-CTRL-v) <C-v>

" highlight group
highlight link OperatorSandwichBuns IncSearch

""" default keymappings
" If g:operator_sandwich_no_default_key_mappings has been defined, then quit immediately.
if exists('g:operator_sandwich_no_default_key_mappings') | finish | endif

" add
silent! nmap <unique> sa <Plug>(operator-sandwich-add)
silent! xmap <unique> sa <Plug>(operator-sandwich-add)

" delete
silent! xmap <unique> sd <Plug>(operator-sandwich-delete)

" replace
silent! xmap <unique> sr <Plug>(operator-sandwich-replace)
