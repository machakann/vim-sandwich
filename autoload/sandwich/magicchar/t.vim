" variables "{{{
let s:null_coord = [0, 0]

" types
let s:type_num  = type(0)
let s:type_str  = type('')
let s:type_list = type([])
"}}}

function! sandwich#magicchar#t#tag() abort "{{{
  call operator#sandwich#show()
  try
    echohl MoreMsg
    let old_imsearch = &l:imsearch
    let &l:imsearch = 0
    let tag = input('Input tag: ')
    let &l:imsearch = old_imsearch
    " flash prompt
    echo ''
  finally
    echohl NONE
    call operator#sandwich#quench()
  endtry
  if tag ==# ''
    throw 'OperatorSandwichCancel'
  endif
  let [open, close] = s:expand(tag)
  return [printf('<%s>', open), printf('</%s>', close)]
endfunction
"}}}
function! sandwich#magicchar#t#tagname() abort "{{{
  call operator#sandwich#show()
  try
    echohl MoreMsg
    let old_imsearch = &l:imsearch
    let &l:imsearch = 0
    let tagname = input('Input tag name: ')
    let &l:imsearch = old_imsearch
    " flash prompt
    echo ''
  finally
    echohl NONE
    call operator#sandwich#quench()
  endtry
  if tagname ==# ''
    throw 'OperatorSandwichCancel'
  endif
  return s:expand(tagname)
endfunction
"}}}
function! s:tokenize(text) abort  "{{{
  let j = 0
  let n = strlen(a:text)
  let tokenlist = []
  while j >= 0 && j < n
    let i = j
    let j = match(a:text, '\m[[[:blank:]#.]', i)
    if i < j
      let tokenlist += [a:text[i : j-1]]
    elseif i == j
      let char = a:text[i]
      if char =~# '\m\s'
        " space is not allowed
        throw 'SandwichMagiccharTIncorrectSyntax'
      elseif char ==# '['
        " tokenize custom attributes
        let tokenlist += [char]
        let j += 1
        let [j, tokenlist] += s:tokenize_custom_attributes(a:text, j)
      else
        let tokenlist += [char]
        let j += 1
      endif
    endif
  endwhile

  let i = j >= 0 ? j : i
  if i < n
    let tokenlist += [a:text[i :]]
  endif
  return tokenlist
endfunction
"}}}
function! s:tokenize_custom_attributes(text, j) abort "{{{
  let j = a:j
  let n = strlen(a:text)
  let closed = 0
  let tokenlist = []
  while j >= 0 && j < n
    let i = j
    let j = match(a:text, '\m[][:blank:]="'']', i)
    if i < j
      let string = a:text[i : j-1]
      let tokenlist += [string]
    elseif i == j
      let char = a:text[i]
      if char =~# '\m\s'
        " skip space
        let j = matchend(a:text, '\m\s\+', i)
        if j > i
          let tokenlist += [a:text[i : j-1]]
        endif
      elseif char =~# '\m["'']'
        " skip string literal
        let j = match(a:text, char, i+1)
        if j > 0
          let tokenlist += [a:text[i : j]]
          let j += 1
        else
          " unclosed string literal
          throw 'SandwichMagiccharTIncorrectSyntax'
        endif
      elseif char ==# ']'
        " the end of custom attributes region
        let tokenlist += [char]
        let j += 1
        let closed = 1
        break
      else
        let tokenlist += [char]
        let j += 1
      endif
    endif
  endwhile
  if !closed
    " unclosed braket
    throw 'SandwichMagiccharTIncorrectSyntax'
  endif
  return [j - a:j, tokenlist]
endfunction
"}}}


function! s:matches_filetype(filetype, list) abort "{{{
  return index(a:list, a:filetype) != -1
endfunction
" }}}

function! s:parse(tokenlist) abort  "{{{
  let itemdict = deepcopy(s:itemdict)
  let itemlist = map(copy(a:tokenlist), '{"is_operator": v:val =~# ''^\%([][#.=]\|\s\+\)$'' ? 1 : 0, "string": v:val}')

  let i = 0
  let n = len(itemlist)
  let item = itemlist[i]
  if item.is_operator
    call itemdict.queue_element('div')
  else
    call itemdict.queue_element(item.string)
    let i += 1
  endif
  while i < n
    let item = itemlist[i]
    if item.is_operator
      if item.string ==# '#'
        let i = s:handle_id(itemdict, itemlist, i)
      elseif item.string ==# '.'
        if s:matches_filetype(&filetype, g:sandwich#jsx_filetypes)
          let i = s:handle_className(itemdict, itemlist, i)
        else
          let i = s:handle_class(itemdict, itemlist, i)
        endif
      elseif item.string ==# '['
        let i = s:parse_custom_attributes(itemdict, itemlist, i)
      else
        " unanticipated operator (should not reach here)
        throw 'SandwichMagiccharTIncorrectSyntax'
      endif
    else
      " successive operand is not allowed here (should not reach here)
      throw 'SandwichMagiccharTIncorrectSyntax'
    endif
  endwhile

  let parsed = deepcopy(itemdict.queue)
  for item in parsed
    call filter(item, 'v:key =~# ''\%(name\|value\)''')
  endfor
  return parsed
endfunction
"}}}
function! s:parse_custom_attributes(itemdict, itemlist, i) abort  "{{{
  " check ket
  let i_ket = s:check_ket(a:itemlist, a:i)
  if i_ket < 0
    " ket does not exist (should not reach here)
    throw 'SandwichMagiccharTIncorrectSyntax'
  endif

  let i = a:i + 1
  while i < i_ket
    let item = a:itemlist[i]
    if item.is_operator
      if item.string ==# '='
        let i = s:handle_equal(a:itemdict, a:itemlist, i)
      else
        let i += 1
      endif
    else
      let i = s:handle_custom_attr_name(a:itemdict, a:itemlist, i)
    endif
  endwhile
  call a:itemdict.queue_custom_attr()
  return i_ket + 1
endfunction
"}}}
function! s:handle_id(itemdict, itemlist, i) abort  "{{{
  let i = a:i + 1
  let item = get(a:itemlist, i, {'is_operator': 1})
  if item.is_operator
    call a:itemdict.queue_id()
  else
    call a:itemdict.queue_id(item.string)
    let i += 1
  endif
  return i
endfunction
"}}}
function! s:handle_class(itemdict, itemlist, i) abort  "{{{
  let i = a:i + 1
  let item = get(a:itemlist, i, {'is_operator': 1})
  if item.is_operator
    call a:itemdict.queue_class()
  else
    call a:itemdict.queue_class(item.string)
    let i += 1
  endif
  return i
endfunction
"}}}
function! s:handle_className(itemdict, itemlist, i) abort  "{{{
  let i = a:i + 1
  let item = get(a:itemlist, i, {'is_operator': 1})
  if item.is_operator
    call a:itemdict.queue_className()
  else
    call a:itemdict.queue_className(item.string)
    let i += 1
  endif
  return i
endfunction
"}}}
function! s:handle_equal(itemdict, itemlist, i, ...) abort "{{{
  let i = a:i + 1
  let item = a:itemlist[i]
  let name = get(a:000, 0, '')
  if item.is_operator
    if item.string ==# '='
      call a:itemdict.list_custom_attr(name)
    else
      call a:itemdict.list_custom_attr(name)
      let i += 1
    endif
  else
    call a:itemdict.list_custom_attr(name, item.string)
    let i += 1
  endif
  return i
endfunction
"}}}
function! s:handle_custom_attr_name(itemdict, itemlist, i) abort "{{{
  let item = a:itemlist[a:i]
  let name = item.string
  let i = a:i + 1
  let item = a:itemlist[i]
  if item.is_operator
    if item.string ==# '='
      let i = s:handle_equal(a:itemdict, a:itemlist, i, name)
    else
      call a:itemdict.list_custom_attr(name)
      let i += 1
    endif
  else
    call a:itemdict.list_custom_attr(name)
  endif
  return i
endfunction
"}}}
function! s:check_ket(itemlist, i) abort  "{{{
  let i = a:i + 1
  let n = len(a:itemlist)
  let i_ket = -1
  while i < n
    let item = a:itemlist[i]
    if item.is_operator && item.string ==# ']'
      let i_ket = i
      break
    endif
    let i += 1
  endwhile
  return i_ket
endfunction
"}}}
function! s:build(itemlist) abort "{{{
  let fragments = [a:itemlist[0]['value']]
  if len(a:itemlist) > 1
    for item in a:itemlist[1:]
      let name = item.name
      let value = type(item.value) == s:type_list ? join(filter(item.value, 'v:val !=# ""')) : item.value
      let value = value !~# '^\(["'']\).*\1$' ? printf('"%s"', value) : value
      let fragments += [printf('%s=%s', name, value)]
    endfor
  endif
  return join(fragments)
endfunction
"}}}
function! s:expand(text) abort  "{{{
  try
    let tokenlist = s:tokenize(a:text)
    let itemlist = s:parse(tokenlist)
  catch /^SandwichMagiccharTIncorrectSyntax$/
    return [a:text, matchstr(a:text, '^\s*\zs\a[^[:blank:]>/]*')]
  endtry
  let element = itemlist[0]['value']
  return [s:build(itemlist), element]
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
  execute printf('silent! normal! v%dat', v:count1)
  execute "normal! \<Esc>"
  if getpos("'<") != getpos("'>")
    normal! gv
    let pat = a:kind ==# 'i' ? '</\ze\a[^[:blank:]>/]*' : '</\a[^[:blank:]>/]*\ze\s*>'
    call search(pat, 'be', line("'<"))
    normal! o
    let pat = a:kind ==# 'i' ? '<\a[^[:blank:]>/]*\zs\_.' : '<\zs\a[^[:blank:]>/]*'
    call search(pat, '', line("'>"))
  else
    call winrestview(view)
    call setpos("'<", visualhead)
    call setpos("'>", visualtail)
  endif
endfunction
"}}}
function! sandwich#magicchar#t#it() abort "{{{
  call s:textobj('i')
endfunction
"}}}
function! sandwich#magicchar#t#at() abort "{{{
  call s:textobj('a')
endfunction
"}}}
function! s:textobj(a_or_i) abort "{{{
  let head = searchpos('<\a[^[:blank:]>/]*', 'bcn', 0, 50)
  if head != s:null_coord
    let tagname = matchstr(getline(head[0])[head[1]-1 :], '^<\zs\a[^[:blank:]>/]*')
    if search(printf('</%s>', s:escape(tagname)), 'cn', 0, 50)
      " add :silent! to suppress errorbell
      if a:a_or_i ==# 'i'
        silent! normal! vit
      else
        silent! normal! vat
      endif
    endif
  endif
endfunction
"}}}
function! s:escape(string) abort  "{{{
  return escape(a:string, '~"\.^$[]*')
endfunction
"}}}

" itemdict object "{{{
let s:itemdict = {
      \   'element': {'name': 'element', 'value': ''},
      \   'id'     : {'name': 'id',      'value': '', 'queued': 0},
      \   'class'  : {'name': 'class',   'value': [], 'queued': 0},
      \   'className'  : {'name': 'className',   'value': [], 'queued': 0},
      \   'queue'  : [],
      \   'customlist': [],
      \ }

function! s:itemdict.queue_element(value) dict abort  "{{{
  let self.element.value = a:value
  call add(self.queue, self.element)
endfunction
"}}}
function! s:itemdict.queue_id(...) dict abort  "{{{
  let self.id.value = get(a:000, 0, '')
  if !self.id.queued
    call add(self.queue, self.id)
    let self.id.queued = 1
  endif
endfunction
"}}}
function! s:itemdict.queue_class(...) dict abort  "{{{
  call add(self.class.value, get(a:000, 0, ''))
  if !self.class.queued
    call add(self.queue, self.class)
    let self.class.queued = 1
  endif
endfunction
"}}}
function! s:itemdict.queue_className(...) dict abort  "{{{
  call add(self.className.value, get(a:000, 0, ''))
  if !self.className.queued
    call add(self.queue, self.className)
    let self.className.queued = 1
  endif
endfunction
"}}}
function! s:itemdict.queue_custom_attr() dict abort "{{{
  if self.customlist != []
    call extend(self.queue, remove(self.customlist, 0, -1))
  endif
endfunction
"}}}
function! s:itemdict.list_custom_attr(name, ...) dict abort "{{{
  let value = get(a:000, 0, '')
  if a:name ==# 'id'
    call self.queue_id(value)
  elseif a:name ==# 'class'
    call self.queue_class(value)
  endif

  if a:name ==# ''
    let custom_attr = {'kind': 'custom', 'name': a:name, 'value': value}
    call add(self.customlist, custom_attr)
  else
    if !has_key(self, a:name)
      let self[a:name] = {'kind': 'custom', 'name': a:name, 'value': value}
      call add(self.customlist, self[a:name])
    else
      let self[a:name]['value'] = value
    endif
  endif
endfunction
"}}}
"}}}



" vim:set foldmethod=marker:
" vim:set commentstring="%s:
