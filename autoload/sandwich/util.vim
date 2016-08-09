function! sandwich#util#echo(messages) abort  "{{{
  echo ''
  for [mes, hi_group] in a:messages
    execute 'echohl ' . hi_group
    echon mes
    echohl NONE
  endfor
endfunction
"}}}
function! sandwich#util#with_operator(name) abort "{{{
  let operator = v:operator ==# 'g@'
        \ ? matchstr(&operatorfunc, '^operator#sandwich#\zs\%(add\|delete\|replace\)$')
        \ : ''
  return a:name ==# operator
endfunction
"}}}


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
