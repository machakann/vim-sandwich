" The vim operator plugin to do well with 'sandwich' like structure
" Last Change: 31-Oct-2021.
" Maintainer : Masaaki Nakamura <mckn@outlook.jp>

" License    : NYSL
"              Japanese <http://www.kmonos.net/nysl/>
"              English (Unofficial) <http://www.kmonos.net/nysl/index.en.html>

if &compatible || exists("g:loaded_operator_sandwich")
  finish
endif
let g:loaded_operator_sandwich = 1

" keymappings
nmap <silent> <Plug>(operator-sandwich-add)     <Plug>(operator-sandwich-add-pre)<Plug>(operator-sandwich-g@)
xmap <silent> <Plug>(operator-sandwich-add)     <Plug>(operator-sandwich-add-pre)<Plug>(operator-sandwich-gv)<Plug>(operator-sandwich-g@)
omap <silent> <Plug>(operator-sandwich-add)     <Plug>(operator-sandwich-g@)
nmap <silent> <Plug>(operator-sandwich-delete)  <Plug>(operator-sandwich-delete-pre)<Plug>(operator-sandwich-g@)
xmap <silent> <Plug>(operator-sandwich-delete)  <Plug>(operator-sandwich-delete-pre)<Plug>(operator-sandwich-gv)<Plug>(operator-sandwich-g@)
omap <silent> <Plug>(operator-sandwich-delete)  <Plug>(operator-sandwich-g@)
nmap <silent> <Plug>(operator-sandwich-replace) <Plug>(operator-sandwich-replace-pre)<Plug>(operator-sandwich-g@)
xmap <silent> <Plug>(operator-sandwich-replace) <Plug>(operator-sandwich-replace-pre)<Plug>(operator-sandwich-gv)<Plug>(operator-sandwich-g@)
omap <silent> <Plug>(operator-sandwich-replace) <Plug>(operator-sandwich-g@)

nnoremap <silent> <Plug>(operator-sandwich-add-pre)     :<C-u>call operator#sandwich#prerequisite('add', 'n')<CR>
xnoremap <silent> <Plug>(operator-sandwich-add-pre)     <Esc>:call operator#sandwich#prerequisite('add', 'x')<CR>
nnoremap <silent> <Plug>(operator-sandwich-delete-pre)  :<C-u>call operator#sandwich#prerequisite('delete', 'n')<CR>
xnoremap <silent> <Plug>(operator-sandwich-delete-pre)  <Esc>:call operator#sandwich#prerequisite('delete', 'x')<CR>
nnoremap <silent> <Plug>(operator-sandwich-replace-pre) :<C-u>call operator#sandwich#prerequisite('replace', 'n')<CR>
xnoremap <silent> <Plug>(operator-sandwich-replace-pre) <Esc>:call operator#sandwich#prerequisite('replace', 'x')<CR>

nnoremap <silent> <Plug>(operator-sandwich-add-query1st)     :<C-u>call operator#sandwich#query1st('add', 'n')<CR>
xnoremap <silent> <Plug>(operator-sandwich-add-query1st)     <Esc>:call operator#sandwich#query1st('add', 'x')<CR>
nnoremap <silent> <Plug>(operator-sandwich-replace-query1st) :<C-u>call operator#sandwich#query1st('replace', 'n')<CR>
xnoremap <silent> <Plug>(operator-sandwich-replace-query1st) <Esc>:call operator#sandwich#query1st('replace', 'x')<CR>

" supplementary keymappings
onoremap <expr><silent> <Plug>(operator-sandwich-synchro-count) operator#sandwich#synchro_count()
onoremap <expr><silent> <Plug>(operator-sandwich-release-count) operator#sandwich#release_count()
onoremap <expr><silent> <Plug>(operator-sandwich-squash-count)  operator#sandwich#squash_count()
nnoremap <expr><silent> <Plug>(operator-sandwich-predot) operator#sandwich#predot()
nnoremap <expr><silent> <Plug>(operator-sandwich-dot)    operator#sandwich#dot()

" visualrepeat.vim (vimscript #3848) support
noremap <silent> <Plug>(operator-sandwich-add-visualrepeat)     :<C-u>call operator#sandwich#visualrepeat('add')<CR>
noremap <silent> <Plug>(operator-sandwich-delete-visualrepeat)  :<C-u>call operator#sandwich#visualrepeat('delete')<CR>
noremap <silent> <Plug>(operator-sandwich-replace-visualrepeat) :<C-u>call operator#sandwich#visualrepeat('replace')<CR>

" intrinsic keymappings
noremap  <Plug>(operator-sandwich-g@) g@
inoremap <Plug>(operator-sandwich-g@) <C-o>g@
nnoremap <Plug>(operator-sandwich-gv) gv
inoremap <Plug>(operator-sandwich-gv) <C-o>gv

" use of vim-event-DotCommandPre
if !hasmapto('<Plug>(operator-sandwich-predot)') && !hasmapto('<Plug>(operator-sandwich-dot)') && (hasmapto('<Plug>(event-DotCommandPre)') || hasmapto('<Plug>(event-DotCommandPre+Dot)'))
  augroup sandwich-predot
    autocmd User DotCommandPre call operator#sandwich#predot()
  augroup END
endif
