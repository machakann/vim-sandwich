" The set of operator/textobj plugins to do well with 'sandwich' like structure
" Last Change: 18-Jan-2022.
" Maintainer : Masaaki Nakamura <mckn@outlook.jp>

" License    : NYSL
"              Japanese <http://www.kmonos.net/nysl/>
"              English (Unofficial) <http://www.kmonos.net/nysl/index.en.html>

if &compatible || exists("g:loaded_sandwich")
  finish
endif
let g:loaded_sandwich = 1

" intrinsic keymappings
onoremap <silent> <Plug>(textobj-sandwich-function-ip) :<C-u>call sandwich#magicchar#f#ip('o')<CR>
onoremap <silent> <Plug>(textobj-sandwich-function-i)  :<C-u>call sandwich#magicchar#f#i('o')<CR>
xnoremap <silent> <Plug>(textobj-sandwich-function-ip) :<C-u>call sandwich#magicchar#f#ip('x')<CR>
xnoremap <silent> <Plug>(textobj-sandwich-function-i)  :<C-u>call sandwich#magicchar#f#i('x')<CR>
onoremap <silent> <Plug>(textobj-sandwich-function-ap) :<C-u>call sandwich#magicchar#f#ap('o')<CR>
onoremap <silent> <Plug>(textobj-sandwich-function-a)  :<C-u>call sandwich#magicchar#f#a('o')<CR>
xnoremap <silent> <Plug>(textobj-sandwich-function-ap) :<C-u>call sandwich#magicchar#f#ap('x')<CR>
xnoremap <silent> <Plug>(textobj-sandwich-function-a)  :<C-u>call sandwich#magicchar#f#a('x')<CR>
onoremap <silent> <Plug>(textobj-sandwich-tagname-i) :<C-u>call sandwich#magicchar#t#i()<CR>
onoremap <silent> <Plug>(textobj-sandwich-tagname-a) :<C-u>call sandwich#magicchar#t#a()<CR>
xnoremap <silent> <Plug>(textobj-sandwich-tagname-i) :<C-u>call sandwich#magicchar#t#i()<CR>
xnoremap <silent> <Plug>(textobj-sandwich-tagname-a) :<C-u>call sandwich#magicchar#t#a()<CR>
onoremap <silent> <Plug>(textobj-sandwich-tag-i) :<C-u>call sandwich#magicchar#t#it()<CR>
onoremap <silent> <Plug>(textobj-sandwich-tag-a) :<C-u>call sandwich#magicchar#t#at()<CR>
xnoremap <silent> <Plug>(textobj-sandwich-tag-i) :<C-u>call sandwich#magicchar#t#it()<CR>
xnoremap <silent> <Plug>(textobj-sandwich-tag-a) :<C-u>call sandwich#magicchar#t#at()<CR>

nmap <silent> <Plug>(sandwich-add) <Plug>(operator-sandwich-add)
xmap <silent> <Plug>(sandwich-add) <Plug>(operator-sandwich-add)
omap <silent> <Plug>(sandwich-add) <Plug>(operator-sandwich-add)
nmap <silent> <Plug>(sandwich-delete) <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
xmap <silent> <Plug>(sandwich-delete) <Plug>(operator-sandwich-delete)
nmap <silent> <Plug>(sandwich-replace) <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
xmap <silent> <Plug>(sandwich-replace) <Plug>(operator-sandwich-replace)
nmap <silent> <Plug>(sandwich-delete-auto) <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
nmap <silent> <Plug>(sandwich-replace-auto) <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

""" default keymappings
" If g:sandwich_no_default_key_mappings has been defined, then quit immediately.
if exists('g:sandwich_no_default_key_mappings') | finish | endif

if !exists('g:operator_sandwich_no_default_key_mappings')
  " add
  silent! nmap <unique> sa <Plug>(sandwich-add)
  silent! xmap <unique> sa <Plug>(sandwich-add)
  silent! omap <unique> sa <Plug>(sandwich-add)

  " delete
  silent! nmap <unique> sd <Plug>(sandwich-delete)
  silent! xmap <unique> sd <Plug>(sandwich-delete)
  silent! nmap <unique> sdb <Plug>(sandwich-delete-auto)

  " replace
  silent! nmap <unique> sr <Plug>(sandwich-replace)
  silent! xmap <unique> sr <Plug>(sandwich-replace)
  silent! nmap <unique> srb <Plug>(sandwich-replace-auto)
endif

if !exists('g:textobj_sandwich_no_default_key_mappings')
  " auto
  silent! omap <unique> ib <Plug>(textobj-sandwich-auto-i)
  silent! xmap <unique> ib <Plug>(textobj-sandwich-auto-i)
  silent! omap <unique> ab <Plug>(textobj-sandwich-auto-a)
  silent! xmap <unique> ab <Plug>(textobj-sandwich-auto-a)

  " query
  silent! omap <unique> is <Plug>(textobj-sandwich-query-i)
  silent! xmap <unique> is <Plug>(textobj-sandwich-query-i)
  silent! omap <unique> as <Plug>(textobj-sandwich-query-a)
  silent! xmap <unique> as <Plug>(textobj-sandwich-query-a)
endif
