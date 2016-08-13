function! sandwich#util#echo(messages) abort  "{{{
  echo ''
  for [mes, hi_group] in a:messages
    execute 'echohl ' . hi_group
    echon mes
    echohl NONE
  endfor
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
