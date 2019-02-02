if &compatible || exists('b:did_sandwich_julia_ftplugin') || get(g:, 'sandwich_no_julia_ftplugin', 0)
  finish
endif

" To include multibyte characters
let b:sandwich_magicchar_f_patterns = [
  \   {
  \     'header' : '\%#=2\<[[:upper:][:lower:]_]\k*!\?',
  \     'bra'    : '(',
  \     'ket'    : ')',
  \     'footer' : '',
  \   },
  \ ]

let b:did_sandwich_julia_ftplugin = 1
if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
else
  let b:undo_ftplugin .= ' | '
endif
let b:undo_ftplugin .= 'unlet! b:did_sandwich_julia_ftplugin b:sandwich_magicchar_f_patterns'
