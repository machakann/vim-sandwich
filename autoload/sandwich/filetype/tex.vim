let g:sandwich#filetype#tex#environments = get(g:, 'sandwich#filetype#tex#environments', [
    \   'array', 'center', 'description', 'enumerate', 'eqnarray', 'equation',
    \   'equation*', 'figure', 'flushleft', 'flushright', 'itemize', 'list',
    \   'minipage', 'picture', 'quotation', 'quote', 'tabbing', 'table',
    \   'tabular', 'tabular*', 'thebibliography', 'theorem', 'titlepage',
    \   'verbatim', 'verse'
    \ ])

function! sandwich#filetype#tex#EnvCompl(argread, cmdline, cursorpos) abort
  let n = strlen(a:argread)
  if exists('b:sandwich#filetype#tex#environments')
    let list = copy(b:sandwich#filetype#tex#environments)
  else
    let list = copy(g:sandwich#filetype#tex#environments)
  endif
  if n > 0
    let list = filter(list, 'v:val[: n-1] ==# a:argread')
  endif
  return list
endfunction

function! sandwich#filetype#tex#EnvInput() abort
  echohl MoreMsg
  let env = input('Environment-name: ', '', 'customlist,sandwich#filetype#tex#EnvCompl')
  echohl NONE
  return [printf('\begin{%s}', env), printf('\end{%s}', env)]
endfunction

function! sandwich#filetype#tex#CmdInput() abort
  echohl MoreMsg
  let cmd = input('Command: ', '')
  echohl NONE
  return [printf('\%s{', cmd), '}']
endfunction
