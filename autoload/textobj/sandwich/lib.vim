" common functions

" variables "{{{
" null valiables
let s:null_coord  = [0, 0]

" patchs
if v:version > 704 || (v:version == 704 && has('patch237'))
  let s:has_patch_7_4_358 = has('patch-7.4.358')
else
  let s:has_patch_7_4_358 = v:version == 704 && has('patch358')
endif
"}}}

function! textobj#sandwich#lib#get() abort "{{{
  return s:lib
endfunction
"}}}

let s:lib = {}
function! s:lib.c2p(coord) abort  "{{{
  return [0] + a:coord + [0]
endfunction
"}}}
function! s:lib.escape(string) abort  "{{{
  return escape(a:string, '~"\.^$[]*')
endfunction
"}}}
" function! s:lib.sort(list, func, count) abort  "{{{
if s:has_patch_7_4_358
  function! s:lib.sort(list, func, count) abort
    return sort(a:list, a:func)
  endfunction
else
  function! s:lib.sort(list, func, count) abort
    " NOTE: len(a:list) is always larger than count or same.
    " FIXME: The number of item in a:list would not be large, but if there was
    "        any efficient argorithm, I would rewrite here.
    let len = len(a:list)
    for i in range(a:count)
      if len - 2 >= i
        let min = len - 1
        for j in range(len - 2, i, -1)
          if call(a:func, [a:list[min], a:list[j]]) >= 0
            let min = j
          endif
        endfor

        if min > i
          call insert(a:list, remove(a:list, min), i)
        endif
      endif
    endfor
    return a:list
  endfunction
endif
"}}}
function! s:lib.get_displaycoord(coord) abort "{{{
  let [lnum, col] = a:coord

  if [lnum, col] != s:null_coord
    let disp_col = col == 1 ? 1 : strdisplaywidth(getline(lnum)[: col - 2]) + 1
  else
    let disp_col = 0
  endif
  return [lnum, disp_col]
endfunction
"}}}
function! s:lib.set_displaycoord(disp_coord) abort "{{{
  if a:disp_coord != s:null_coord
    execute 'normal! ' . a:disp_coord[0] . 'G' . a:disp_coord[1] . '|'
  endif
endfunction
"}}}



" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
