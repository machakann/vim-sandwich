" constants - storing essential constants

" variables "{{{
" types
let s:type_list = type([])
"}}}

function! sandwich#constants#get(name) abort  "{{{
  return type(a:name) == s:type_list
     \ ? map(copy(a:name), 's:constants[v:val]()')
     \ : s:constants[a:name]()
endfunction
"}}}

" s:constants "{{{
let s:constants = {}
"}}}
" The maximum number of columns "{{{
function! s:constants.colmax() dict abort
  return s:colmax_obtained ? s:colmax : s:colmax()
endfunction

let s:colmax = 2147483647   " default value in many cases
let s:colmax_obtained = 0
function! s:colmax() abort
  let view = winsaveview()
  try
    normal! $
    let colmax = winsaveview().curswant
    call winrestview(view)
    let s:colmax_obtained = 1
  catch
    let colmax = s:colmax
    let s:colmax_obtained = 0
  endtry
  return colmax
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
