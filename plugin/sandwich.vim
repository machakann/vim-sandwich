" The set of operator/textobj plugins to do well with 'sandwich' like structure
" Last Change: 23-Oct-2021.
" Maintainer : Masaaki Nakamura <mckn@outlook.jp>

" License    : NYSL
"              Japanese <http://www.kmonos.net/nysl/>
"              English (Unofficial) <http://www.kmonos.net/nysl/index.en.html>

if &compatible || exists("g:loaded_sandwich")
  finish
endif
let g:loaded_sandwich = 1

" intrinsic keymappings
onoremap <silent> <Plug>(textobj-sandwich-function-ip) :<C-u>call sandwich#magicchar#f#ip()<CR>
onoremap <silent> <Plug>(textobj-sandwich-function-i)  :<C-u>call sandwich#magicchar#f#i()<CR>
xnoremap <silent> <Plug>(textobj-sandwich-function-ip) :<C-u>call sandwich#magicchar#f#ip()<CR>
xnoremap <silent> <Plug>(textobj-sandwich-function-i)  :<C-u>call sandwich#magicchar#f#i()<CR>
onoremap <silent> <Plug>(textobj-sandwich-function-ap) :<C-u>call sandwich#magicchar#f#ap()<CR>
onoremap <silent> <Plug>(textobj-sandwich-function-a)  :<C-u>call sandwich#magicchar#f#a()<CR>
xnoremap <silent> <Plug>(textobj-sandwich-function-ap) :<C-u>call sandwich#magicchar#f#ap()<CR>
xnoremap <silent> <Plug>(textobj-sandwich-function-a)  :<C-u>call sandwich#magicchar#f#a()<CR>
onoremap <silent> <Plug>(textobj-sandwich-tagname-i) :<C-u>call sandwich#magicchar#t#i()<CR>
onoremap <silent> <Plug>(textobj-sandwich-tagname-a) :<C-u>call sandwich#magicchar#t#a()<CR>
xnoremap <silent> <Plug>(textobj-sandwich-tagname-i) :<C-u>call sandwich#magicchar#t#i()<CR>
xnoremap <silent> <Plug>(textobj-sandwich-tagname-a) :<C-u>call sandwich#magicchar#t#a()<CR>
onoremap <silent> <Plug>(textobj-sandwich-tag-i) :<C-u>call sandwich#magicchar#t#it()<CR>
onoremap <silent> <Plug>(textobj-sandwich-tag-a) :<C-u>call sandwich#magicchar#t#at()<CR>
xnoremap <silent> <Plug>(textobj-sandwich-tag-i) :<C-u>call sandwich#magicchar#t#it()<CR>
xnoremap <silent> <Plug>(textobj-sandwich-tag-a) :<C-u>call sandwich#magicchar#t#at()<CR>

map <silent> <Plug>(sandwich-add) <Plug>(operator-sandwich-add)
nmap <silent> <Plug>(sandwich-delete) <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
xmap <silent> <Plug>(sandwich-delete) <Plug>(operator-sandwich-delete)
nmap <silent> <Plug>(sandwich-replace) <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
xmap <silent> <Plug>(sandwich-replace) <Plug>(operator-sandwich-replace)
nmap <silent> <Plug>(sandwich-delete-auto) <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
nmap <silent> <Plug>(sandwich-replace-auto) <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

""" default keymappings
" If g:sandwich_no_default_key_mappings has been defined, then quit immediately.
if exists('g:sandwich_no_default_key_mappings') | finish | endif

silent! nmap <unique><silent> sd <Plug>(sandwich-delete)
silent! nmap <unique><silent> sr <Plug>(sandwich-replace)
silent! nmap <unique><silent> sdb <Plug>(sandwich-delete-auto)
silent! nmap <unique><silent> srb <Plug>(sandwich-replace-auto)
