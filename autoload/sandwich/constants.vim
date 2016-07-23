" constants - storing essential constants

" variables "{{{
" types
let s:type_list = type([])
"}}}

function! sandwich#constants#get(name) abort  "{{{
  return type(a:name) == s:type_list
     \ ? map(copy(a:name), 's:constants[v:val]')
     \ : s:constants[a:name]
endfunction
"}}}

" s:constants "{{{
let s:constants = {}
"}}}
" The maximum number of columns "{{{
function! s:colmax() abort
  let view = winsaveview()
  normal! $
  let colmax = winsaveview().curswant
  call winrestview(view)
  return colmax
endfunction
let s:constants.colmax = s:colmax()
delfunction s:colmax
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
