if &compatible || exists('b:did_sandwich_vim_ftplugin') || get(g:, 'sandwich_no_vim_ftplugin', 0)
  finish
endif

let b:sandwich_magicchar_f_patterns = [
  \   {
  \     'header' : '\C\<\%(\h\|[sa]:\h\|g:[A-Z]\)\k*',
  \     'bra'    : '(',
  \     'ket'    : ')',
  \     'footer' : '',
  \   },
  \ ]

let b:did_sandwich_vim_ftplugin = 1
if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
else
  let b:undo_ftplugin .= ' | '
endif
let b:undo_ftplugin .= 'unlet! b:did_sandwich_vim_ftplugin b:sandwich_magicchar_f_patterns'
