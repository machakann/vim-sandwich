function! sandwich#magicchar#t#taginput() abort
  echohl MoreMsg
  let tag = input('Input tag: ')
  echohl NONE
  if tag ==# ''
    throw 'OperatorSandwichCancel'
  endif
  return [printf('<%s>', tag), printf('</%s>', matchstr(tag, '^\a[^[:blank:]>/]*'))]
endfunction
