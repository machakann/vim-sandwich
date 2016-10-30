scriptencoding utf-8

let s:suite = themis#suite('magicchar-t emmet-like behavior:')

let s:scope = themis#helper('scope')
let s:t = s:scope.funcs('autoload/sandwich/magicchar/t.vim')

" test seeds  "{{{
let s:testseeds = {}
let s:testseeds.element = [
      \   {
      \     'input': 'element',
      \     'token': ['element'],
      \     'items': [{'name': 'element', 'value': 'element'}],
      \   },
      \
      \   {
      \     'input': '',
      \     'token': [],
      \     'items': [{'name': 'element', 'value': 'div'}],
      \   },
      \ ]
let s:testseeds.attributes = [
      \   {
      \     'input': '#id1',
      \     'token': ['#', 'id1'],
      \     'items': [{'name': 'id', 'value': 'id1'}],
      \   },
      \
      \   {
      \     'input': '#id2',
      \     'token': ['#', 'id2'],
      \     'items': [{'name': 'id', 'value': 'id2'}],
      \   },
      \
      \   {
      \     'input': '#',
      \     'token': ['#'],
      \     'items': [{'name': 'id', 'value': ''}],
      \   },
      \
      \   {
      \     'input': '.class1',
      \     'token': ['.', 'class1'],
      \     'items': [{'name': 'class', 'value': ['class1']}],
      \   },
      \
      \   {
      \     'input': '.class2',
      \     'token': ['.', 'class2'],
      \     'items': [{'name': 'class', 'value': ['class2']}],
      \   },
      \
      \   {
      \     'input': '.',
      \     'token': ['.'],
      \     'items': [{'name': 'class', 'value': ['']}],
      \   },
      \
      \   {
      \     'input': '[attr=hello]',
      \     'token': ['[', 'attr', '=', 'hello', ']'],
      \     'items': [{'name': 'attr', 'value': 'hello'}],
      \   },
      \
      \   {
      \     'input': '[attr=world]',
      \     'token': ['[', 'attr', '=', 'world', ']'],
      \     'items': [{'name': 'attr', 'value': 'world'}],
      \   },
      \
      \   {
      \     'input': '[hello=world]',
      \     'token': ['[', 'hello', '=', 'world', ']'],
      \     'items': [{'name': 'hello', 'value': 'world'}],
      \   },
      \
      \   {
      \     'input': '[]',
      \     'token': ['[', ']'],
      \     'items': [],
      \   },
      \
      \   {
      \     'input': '[attr="including space"]',
      \     'token': ['[', 'attr', '=', '"including space"', ']'],
      \     'items': [{'name': 'attr', 'value': '"including space"'}],
      \   },
      \
      \   {
      \     'input': '[ attr="including space"]',
      \     'token': ['[', ' ', 'attr', '=', '"including space"', ']'],
      \     'items': [{'name': 'attr', 'value': '"including space"'}],
      \   },
      \
      \   {
      \     'input': '[attr ="including space"]',
      \     'token': ['[', 'attr', ' ', '=', '"including space"', ']'],
      \     'items': [
      \       {'name': 'attr', 'value': ''},
      \       {'name': '',     'value': '"including space"'},
      \     ],
      \   },
      \
      \   {
      \     'input': '[attr= "including space"]',
      \     'token': ['[', 'attr', '=', ' ', '"including space"', ']'],
      \     'items': [
      \       {'name': 'attr',              'value': ''},
      \       {'name': '"including space"', 'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': '[attr="including space" ]',
      \     'token': ['[', 'attr', '=', '"including space"', ' ', ']'],
      \     'items': [{'name': 'attr', 'value': '"including space"'}],
      \   },
      \
      \   {
      \     'input': "[attr='including space']",
      \     'token': ['[', 'attr', '=', "'including space'", ']'],
      \     'items': [{'name': 'attr', 'value': "'including space'"}],
      \   },
      \
      \   {
      \     'input': "[ attr='including space']",
      \     'token': ['[', ' ', 'attr', '=', "'including space'", ']'],
      \     'items': [{'name': 'attr', 'value': "'including space'"}],
      \   },
      \
      \   {
      \     'input': "[attr ='including space']",
      \     'token': ['[', 'attr', ' ', '=', "'including space'", ']'],
      \     'items': [
      \       {'name': 'attr', 'value': ""},
      \       {'name': '',     'value': "'including space'"},
      \     ],
      \   },
      \
      \   {
      \     'input': "[attr= 'including space']",
      \     'token': ['[', 'attr', '=', ' ', "'including space'", ']'],
      \     'items': [
      \       {'name': 'attr',              'value': ""},
      \       {'name': "'including space'", 'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': "[attr='including space' ]",
      \     'token': ['[', 'attr', '=', "'including space'", ' ', ']'],
      \     'items': [{'name': 'attr', 'value': "'including space'"}],
      \   },
      \
      \   {
      \     'input': "[attr=withoutspace]",
      \     'token': ['[', 'attr', '=', 'withoutspace', ']'],
      \     'items': [{'name': 'attr', 'value': 'withoutspace'}],
      \   },
      \
      \   {
      \     'input': "[ attr=withoutspace]",
      \     'token': ['[', ' ', 'attr', '=', 'withoutspace', ']'],
      \     'items': [{'name': 'attr', 'value': 'withoutspace'}],
      \   },
      \
      \   {
      \     'input': "[attr =withoutspace]",
      \     'token': ['[', 'attr', ' ', '=', 'withoutspace', ']'],
      \     'items': [
      \       {'name': 'attr', 'value': ''},
      \       {'name': '',     'value': 'withoutspace'},
      \     ],
      \   },
      \
      \   {
      \     'input': "[attr= withoutspace]",
      \     'token': ['[', 'attr', '=', ' ', 'withoutspace', ']'],
      \     'items': [
      \       {'name': 'attr',         'value': ''},
      \       {'name': 'withoutspace', 'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': "[attr=withoutspace ]",
      \     'token': ['[', 'attr', '=', 'withoutspace', ' ', ']'],
      \     'items': [{'name': 'attr', 'value': 'withoutspace'}],
      \   },
      \
      \   {
      \     'input': "[attr=]",
      \     'token': ['[', 'attr', '=', ']'],
      \     'items': [{'name': 'attr', 'value': ''}],
      \   },
      \
      \   {
      \     'input': "[ attr=]",
      \     'token': ['[', ' ', 'attr', '=', ']'],
      \     'items': [{'name': 'attr', 'value': ''}],
      \   },
      \
      \   {
      \     'input': "[attr =]",
      \     'token': ['[', 'attr', ' ', '=', ']'],
      \     'items': [
      \       {'name': 'attr', 'value': ''},
      \       {'name': '',     'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': "[attr= ]",
      \     'token': ['[', 'attr', '=', ' ', ']'],
      \     'items': [{'name': 'attr', 'value': ''}],
      \   },
      \
      \   {
      \     'input': "[=value]",
      \     'token': ['[', '=', 'value', ']'],
      \     'items': [{'name': '', 'value': 'value'}],
      \   },
      \
      \   {
      \     'input': "[ =value]",
      \     'token': ['[', ' ', '=', 'value', ']'],
      \     'items': [{'name': '', 'value': 'value'}],
      \   },
      \
      \   {
      \     'input': "[= value]",
      \     'token': ['[', '=', ' ', 'value', ']'],
      \     'items': [
      \       {'name': '',      'value': ''},
      \       {'name': 'value', 'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': "[=value ]",
      \     'token': ['[', '=', 'value', ' ', ']'],
      \     'items': [{'name': '', 'value': 'value'}],
      \   },
      \
      \   {
      \     'input': "[==]",
      \     'token': ['[', '=', '=', ']'],
      \     'items': [
      \       {'name': '', 'value': ''},
      \       {'name': '', 'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': "[ ==]",
      \     'token': ['[', ' ', '=', '=', ']'],
      \     'items': [
      \       {'name': '', 'value': ''},
      \       {'name': '', 'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': "[= =]",
      \     'token': ['[', '=', ' ', '=', ']'],
      \     'items': [
      \       {'name': '', 'value': ''},
      \       {'name': '', 'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': "[== ]",
      \     'token': ['[', '=', '=', ' ', ']'],
      \     'items': [
      \       {'name': '', 'value': ''},
      \       {'name': '', 'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': "[attr==]",
      \     'token': ['[', 'attr', '=', '=', ']'],
      \     'items': [
      \       {'name': 'attr', 'value': ''},
      \       {'name': '',     'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': "[=value=]",
      \     'token': ['[', '=', 'value', '=', ']'],
      \     'items': [
      \       {'name': '', 'value': 'value'},
      \       {'name': '', 'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': "[==value]",
      \     'token': ['[', '=', '=', 'value', ']'],
      \     'items': [
      \       {'name': '', 'value': ''},
      \       {'name': '', 'value': 'value'},
      \     ],
      \   },
      \
      \   {
      \     'input': "['word1 word2'==]",
      \     'token': ['[', "'word1 word2'", '=', '=', ']'],
      \     'items': [
      \       {'name': "'word1 word2'", 'value': ''},
      \       {'name': '',              'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': "[='word1 word2'=]",
      \     'token': ['[', '=', "'word1 word2'", '=', ']'],
      \     'items': [
      \       {'name': '', 'value': "'word1 word2'"},
      \       {'name': '', 'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': "[=='word1 word2']",
      \     'token': ['[', '=', '=', "'word1 word2'", ']'],
      \     'items': [
      \       {'name': '', 'value': ''},
      \       {'name': '', 'value': "'word1 word2'"},
      \     ],
      \   },
      \
      \   {
      \     'input': "[attr1=value1 attr2=value2]",
      \     'token': ['[', 'attr1', '=', 'value1', ' ', 'attr2', '=', 'value2', ']'],
      \     'items': [
      \       {'name': 'attr1', 'value': 'value1'},
      \       {'name': 'attr2', 'value': 'value2'},
      \     ],
      \   },
      \
      \   {
      \     'input': "[attr1=value1 attr2]",
      \     'token': ['[', 'attr1', '=', 'value1', ' ', 'attr2', ']'],
      \     'items': [
      \       {'name': 'attr1', 'value': 'value1'},
      \       {'name': 'attr2', 'value': ''},
      \     ],
      \   },
      \
      \   {
      \     'input': "[attr1 attr2=value2]",
      \     'token': ['[', 'attr1', ' ', 'attr2', '=', 'value2', ']'],
      \     'items': [
      \       {'name': 'attr1', 'value': ''},
      \       {'name': 'attr2', 'value': 'value2'},
      \     ],
      \   },
      \
      \   {
      \     'input': "[attr1 attr2]",
      \     'token': ['[', 'attr1', ' ', 'attr2', ']'],
      \     'items': [
      \       {'name': 'attr1', 'value': ''},
      \       {'name': 'attr2', 'value': ''},
      \     ],
      \   },
      \ ]
function! s:testseeds.generate_parsed(itemlist) dict abort  "{{{
  let itemlist = deepcopy(a:itemlist)
  call s:overwrite(itemlist, 'id')
  call s:append(itemlist, 'class')
  let custom_attr_list = map(filter(deepcopy(itemlist), 'has_key(v:val, "name") && v:val.name !~# ''\%(element\|id\|class\)'''), 'v:val.name')
  call s:uniq(filter(custom_attr_list, 'v:val !=# ""'))
  for attr in custom_attr_list
    call s:overwrite(itemlist, attr)
  endfor
  return itemlist
endfunction
"}}}
function! s:overwrite(itemlist, name) abort "{{{
  let i = 0
  let n = len(a:itemlist)
  let i_target = -1
  while i < n
    let item = a:itemlist[i]
    if item.name ==# a:name
      let i_target = i
      break
    endif
    let i += 1
  endwhile
  if i_target > 0
    let i = n - 1
    let value = ''
    let value_is_fixed = 0
    while i > i_target
      let item = a:itemlist[i]
      if item.name ==# a:name
        if !value_is_fixed
          let value = item.value
          let value_is_fixed = 1
        endif
        call remove(a:itemlist, i)
      endif
      let i -= 1
    endwhile
    if value_is_fixed
      let a:itemlist[i_target]['value'] = value
    endif
  endif
endfunction
"}}}
function! s:append(itemlist, name) abort  "{{{
  let i = 0
  let n = len(a:itemlist)
  let i_target = -1
  while i < n
    let item = a:itemlist[i]
    if item.name ==# a:name
      let i_target = i
      break
    endif
    let i += 1
  endwhile
  if i_target > 0
    let i = n - 1
    let value = []
    while i > i_target
      let item = a:itemlist[i]
      if item.name ==# a:name
        let value += item.value
        call remove(a:itemlist, i)
      endif
      let i -= 1
    endwhile
    if value !=# []
      let a:itemlist[i_target]['value'] += reverse(value)
    endif
  endif
endfunction
"}}}
function! s:uniq(list) abort  "{{{
  let i = len(a:list) - 1
  while i > 0
    let item = a:list[i]
    if count(a:list, item) > 1
      call remove(a:list, i)
    endif
    let i -= 1
  endwhile
  return a:list
endfunction
"}}}
"}}}

function! s:suite.tokenize() dict abort "{{{
  " happy paths

  " 1 seed
  for element in deepcopy(s:testseeds.element)
    for attribute1 in deepcopy(s:testseeds.attributes)
      let input = join([element.input, attribute1.input], '')
      let expect = element.token + attribute1.token
      call g:assert.equals(s:t.tokenize(input), expect, 'input: ' . input)
    endfor
  endfor

  " 2 seeds
  for element in deepcopy(s:testseeds.element)
    for attribute1 in deepcopy(s:testseeds.attributes)
      for attribute2 in deepcopy(s:testseeds.attributes)
        let input = join([element.input, attribute1.input, attribute2.input], '')
        let expect = element.token + attribute1.token + attribute2.token
        call g:assert.equals(s:t.tokenize(input), expect, 'input: ' . input)
      endfor
    endfor
  endfor

  " " 3 seeds
  " for element in deepcopy(s:testseeds.element)
  "   for attribute1 in deepcopy(s:testseeds.attributes)
  "     for attribute2 in deepcopy(s:testseeds.attributes)
  "       for attribute3 in deepcopy(s:testseeds.attributes)
  "         let input = join([element.input, attribute1.input, attribute2.input, attribute3.input], '')
  "         let expect = element.token + attribute1.token + attribute2.token + attribute3.token
  "         call g:assert.equals(s:t.tokenize(input), expect, 'input: ' . input)
  "       endfor
  "     endfor
  "   endfor
  " endfor
endfunction
"}}}
function! s:suite.parse() dict abort  "{{{
  " happy paths

  " 1 seed
  for element in deepcopy(s:testseeds.element)
    for attribute1 in deepcopy(s:testseeds.attributes)
      let input = element.token + attribute1.token
      let expect = s:testseeds.generate_parsed(element.items + attribute1.items)
      call g:assert.equals(s:t.parse(input), expect, 'input: ' . string(input))
    endfor
  endfor

  " 2 seeds
  for element in deepcopy(s:testseeds.element)
    for attribute1 in deepcopy(s:testseeds.attributes)
      for attribute2 in deepcopy(s:testseeds.attributes)
        let input = element.token + attribute1.token + attribute2.token
        let expect = s:testseeds.generate_parsed(element.items + attribute1.items + attribute2.items)
        call g:assert.equals(s:t.parse(input), expect, 'input: ' . string(input))
      endfor
    endfor
  endfor

  " " 3 seeds
  " for element in deepcopy(s:testseeds.element)
  "   for attribute1 in deepcopy(s:testseeds.attributes)
  "     for attribute2 in deepcopy(s:testseeds.attributes)
  "       for attribute3 in deepcopy(s:testseeds.attributes)
  "         let input = element.token + attribute1.token + attribute2.token + attribute3.token
  "         let expect = s:testseeds.generate_parsed(element.items + attribute1.items + attribute2.items + attribute3.items)
  "         call g:assert.equals(s:t.parse(input), expect, 'input: ' . string(input))
  "       endfor
  "     endfor
  "   endfor
  " endfor
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
