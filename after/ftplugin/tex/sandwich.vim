if &compatible || exists('b:did_sandwich_tex_ftplugin') || get(g:, 'sandwich_no_tex_ftplugin', 0)
  finish
endif

runtime macros/sandwich/ftplugin/tex.vim

augroup sandwich-event-FileType
  autocmd!
  execute 'autocmd FileType tex source ' . fnameescape(expand('<sfile>'))
augroup END

let b:did_sandwich_tex_ftplugin = 1
if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
else
  let b:undo_ftplugin .= ' | '
endif
let b:undo_ftplugin .= 'unlet b:did_sandwich_tex_ftplugin | call sandwich#util#ftrevert("tex")'
