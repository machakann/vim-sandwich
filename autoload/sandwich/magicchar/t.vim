function! sandwich#magicchar#t#tag() abort "{{{
  call operator#sandwich#show()
  echohl MoreMsg
  let tag = input('Input tag: ')
  echohl NONE
  call operator#sandwich#quench()
  if tag ==# ''
    throw 'OperatorSandwichCancel'
  endif
  let [open, close] = s:expand(tag)
  return [printf('<%s>', open), printf('</%s>', close)]
endfunction
"}}}
function! sandwich#magicchar#t#tagname() abort "{{{
  call operator#sandwich#show()
  echohl MoreMsg
  let tagname = input('Input tag name: ')
  echohl NONE
  call operator#sandwich#quench()
  if tagname ==# ''
    throw 'OperatorSandwichCancel'
  endif
  return s:expand(tagname)
endfunction
"}}}
function! s:tokenize(text) abort  "{{{
  return matchlist(a:text, '^\([[:alnum:]_-]*\)\([#.][^#.[:blank:]]*\)\?\([#.][^#.[:blank:]]*\)\?\(.*\)')[1:4]
endfunction
"}}}
function! s:parse(tokenlist) abort  "{{{
  let itemlist = []

  if a:tokenlist[0] !=# ''
    let itemlist += [{'kind': 'element', 'string': a:tokenlist[0]}]
  else
    let itemlist += [{'kind': 'element', 'string': 'div'}]
  endif

  for i in [1, 2]
    if a:tokenlist[i][0] ==# '#'
      let itemlist += [{'kind': 'id', 'string': a:tokenlist[i][1:]}]
    elseif a:tokenlist[i][0] ==# '.'
      let itemlist += [{'kind': 'class', 'string': a:tokenlist[i][1:]}]
    endif
  endfor

  if a:tokenlist[3] !=# ''
    let string = a:tokenlist[3][0] =~# '\s' ? a:tokenlist[3][1:] : a:tokenlist[3]
    let itemlist += [{'kind': 'unclassified', 'string': string}]
  endif

  return itemlist
endfunction
"}}}
function! s:convert(item) abort "{{{
  if a:item.kind ==# 'element' || a:item.kind ==# 'unclassified'
    let string = a:item.string
  else
    let string = printf('%s="%s"', a:item.kind, a:item.string)
  endif
  return string
endfunction
"}}}
function! s:expand(text) abort  "{{{
  let tokenlist = s:tokenize(a:text)
  let itemlist = s:parse(tokenlist)
  let elementname = itemlist[0]['string']
  return [join(map(itemlist, 's:convert(v:val)')), elementname]
endfunction
"}}}

function! sandwich#magicchar#t#i() abort "{{{
  call s:prototype('i')
endfunction
"}}}
function! sandwich#magicchar#t#a() abort "{{{
  call s:prototype('a')
endfunction
"}}}
function! s:prototype(kind) abort "{{{
  let view = winsaveview()
  let visualhead = getpos("'<")
  let visualtail = getpos("'>")
  execute printf('normal! v%dat', v:count1)
  execute "normal! \<Esc>"
  if getpos("'<") != getpos("'>")
    normal! gv
    let pat = a:kind ==# 'i' ? '</\ze\a[^[:blank:]>/]*' : '</\a[^[:blank:]>/]*\ze\s*>'
    call search(pat, 'be', line("'<"))
    normal! o
    let pat = a:kind ==# 'i' ? '<\a[^[:blank:]>/]*\zs.' : '<\zs\a[^[:blank:]>/]*'
    call search(pat, '', line("'>"))
  else
    call winrestview(view)
    call setpos("'<", visualhead)
    call setpos("'>", visualtail)
  endif
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:

