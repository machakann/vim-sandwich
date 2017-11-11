" The vim operator plugin to do well with 'sandwich' like structure
" Last Change: 09-Nov-2017.
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

" highlight group
function! s:default_highlight() abort
  highlight default link OperatorSandwichBuns   IncSearch
  highlight default link OperatorSandwichAdd    DiffAdd
  highlight default link OperatorSandwichDelete DiffDelete

  if hlexists('OperatorSandwichStuff')
    highlight default link OperatorSandwichChange OperatorSandwichStuff
  else
    " obsolete
    highlight default link OperatorSandwichChange DiffChange
  endif
endfunction
call s:default_highlight()

augroup sandwich-event-ColorScheme
  autocmd!
  autocmd ColorScheme * call s:default_highlight()
augroup END

" use of vim-event-DotCommandPre
if !hasmapto('<Plug>(operator-sandwich-predot)') && !hasmapto('<Plug>(operator-sandwich-dot)') && (hasmapto('<Plug>(event-DotCommandPre)') || hasmapto('<Plug>(event-DotCommandPre+Dot)'))
  augroup sandwich-predot
    autocmd User DotCommandPre call operator#sandwich#predot()
  augroup END
endif

""" default keymappings
" If g:operator_sandwich_no_default_key_mappings has been defined, then quit immediately.
if exists('g:operator_sandwich_no_default_key_mappings') | finish | endif

" add
silent! nmap <unique> sa <Plug>(operator-sandwich-add)
silent! xmap <unique> sa <Plug>(operator-sandwich-add)
silent! omap <unique> sa <Plug>(operator-sandwich-g@)

" delete
silent! xmap <unique> sd <Plug>(operator-sandwich-delete)

" replace
silent! xmap <unique> sr <Plug>(operator-sandwich-replace)
