" textobj-sandwich: pick up a sandwich!
" NOTE: Because of the restriction of vim, if a operator to get the assigned
"       region is employed for 'external' user-defined textobjects, it makes
"       impossible to repeat by dot command. Thus, 'external' is checked by
"       using visual selection xmap in any case.

" variables "{{{
" types
let s:type_str  = type('')
"}}}

""" Public functions
function! textobj#sandwich#auto(mode, a_or_i, ...) abort  "{{{
  " make new textobj object
  let g:textobj#sandwich#object = textobj#sandwich#textobj#new()
  let textobj = g:textobj#sandwich#object

  " set prerequisite initial values
  let textobj.state  = 1
  let textobj.kind   = 'auto'
  let textobj.mode   = a:mode
  let textobj.a_or_i = a:a_or_i
  let textobj.count  = v:count1
  let textobj.cursor = getpos('.')[1:2]
  let textobj.view   = winsaveview()
  let textobj.recipes.arg = get(a:000, 1, [])
  let textobj.recipes.arg_given = a:0 > 1
  let textobj.opt = sandwich#opt#new('textobj')
  let textobj.opt.filter = s:default_opt.filter
  call textobj.opt.update('arg', get(a:000, 0, {}))
  call textobj.opt.update('default', s:default_options(textobj.kind))
  call textobj.recipes.integrate(textobj.kind, textobj.mode, textobj.opt)

  " uniq recipes
  let opt = textobj.opt
  call s:uniq_recipes(textobj.recipes.integrated, opt.of('regex'), opt.of('expr'), opt.of('noremap'))

  if textobj.recipes.integrated != []
    let cmd = ":\<C-u>call textobj#sandwich#select()\<CR>"
  else
    let cmd = a:mode ==# 'o' ? "\<Esc>" : "\<Plug>(sandwich-nop)"
  endif
  return cmd
endfunction
"}}}
function! textobj#sandwich#query(mode, a_or_i, ...) abort  "{{{
  " make new textobj object
  let g:textobj#sandwich#object = textobj#sandwich#textobj#new()
  let textobj = g:textobj#sandwich#object

  " set prerequisite initial values
  let textobj.state  = 1
  let textobj.kind   = 'query'
  let textobj.mode   = a:mode
  let textobj.a_or_i = a:a_or_i
  let textobj.count  = v:count1
  let textobj.cursor = getpos('.')[1:2]
  let textobj.view   = winsaveview()
  let textobj.recipes.arg = get(a:000, 1, [])
  let textobj.recipes.arg_given = a:0 > 1
  let textobj.opt = sandwich#opt#new('textobj')
  let textobj.opt.filter = s:default_opt.filter
  call textobj.opt.update('arg', get(a:000, 0, {}))
  call textobj.opt.update('default', s:default_options(textobj.kind))
  call textobj.recipes.integrate(textobj.kind, textobj.mode, textobj.opt)

  call textobj.query()

  if textobj.recipes.integrated != []
    let cmd = ":\<C-u>call textobj#sandwich#select()\<CR>"
  else
    let cmd = a:mode ==# 'o' ? "\<Esc>" : "\<Plug>(sandwich-nop)"
  endif
  return cmd
endfunction
"}}}
function! textobj#sandwich#select() abort  "{{{
  call g:textobj#sandwich#object.start()
endfunction
"}}}
function! s:default_options(kind) abort "{{{
  return get(b:, 'textobj_sandwich_options', g:textobj#sandwich#options)[a:kind]
endfunction
"}}}


" private functions
function! s:uniq_recipes(recipes, opt_regex, opt_expr, opt_noremap) abort "{{{
  let recipes = copy(a:recipes)
  call filter(a:recipes, 0)
  while recipes != []
    let recipe = remove(recipes, 0)
    call add(a:recipes, recipe)
    if has_key(recipe, 'buns')
      call filter(recipes, '!s:is_duplicated_buns(v:val, recipe, a:opt_regex, a:opt_expr)')
    elseif has_key(recipe, 'external')
      call filter(recipes, '!s:is_duplicated_external(v:val, recipe, a:opt_noremap)')
    endif
  endwhile
endfunction
"}}}
function! s:is_duplicated_buns(item, ref, opt_regex, opt_expr) abort  "{{{
  if has_key(a:item, 'buns')
        \ && type(a:ref['buns'][0]) == s:type_str
        \ && type(a:ref['buns'][1]) == s:type_str
        \ && type(a:item['buns'][0]) == s:type_str
        \ && type(a:item['buns'][1]) == s:type_str
        \ && a:ref['buns'][0] ==# a:item['buns'][0]
        \ && a:ref['buns'][1] ==# a:item['buns'][1]
    let regex_r = get(a:ref,  'regex', a:opt_regex)
    let regex_i = get(a:item, 'regex', a:opt_regex)
    let expr_r  = get(a:ref,  'expr',  a:opt_expr)
    let expr_i  = get(a:item, 'expr',  a:opt_expr)

    let expr_r = expr_r ? 1 : 0
    let expr_i = expr_i ? 1 : 0

    if regex_r == regex_i && expr_r == expr_i
      return 1
    endif
  endif
  return 0
endfunction
"}}}
function! s:is_duplicated_external(item, ref, opt_noremap) abort "{{{
  if has_key(a:item, 'external')
        \ && a:ref['external'][0] ==# a:item['external'][0]
        \ && a:ref['external'][1] ==# a:item['external'][1]
    let noremap_r = get(a:ref,  'noremap', a:opt_noremap)
    let noremap_i = get(a:item, 'noremap', a:opt_noremap)

    if noremap_r == noremap_i
      return 1
    endif
  endif

  return 0
endfunction
"}}}
let [s:get] = textobj#sandwich#lib#funcref(['get'])

" recipe  "{{{
function! textobj#sandwich#get_recipes() abort  "{{{
  if exists('b:textobj_sandwich_recipes')
    let recipes = b:textobj_sandwich_recipes
  elseif exists('g:textobj#sandwich#recipes')
    let recipes = g:textobj#sandwich#recipes
  else
    let recipes = g:textobj#sandwich#default_recipes
  endif
  return deepcopy(recipes)
endfunction
"}}}
if exists('g:textobj#sandwich#default_recipes')
  unlockvar! g:textobj#sandwich#default_recipes
endif
let g:textobj#sandwich#default_recipes = [
      \   {'buns': ['input("textobj-sandwich:head: ")', 'input("textobj-sandwich:tail: ")'], 'kind': ['delete', 'replace', 'query'], 'expr': 1, 'regex': 1, 'synchro': 1, 'input': ['i']},
      \ ]
lockvar! g:textobj#sandwich#default_recipes
"}}}

" options "{{{
let s:default_opt = {}
let s:default_opt.auto = {
      \   'expr'           : 0,
      \   'regex'          : 0,
      \   'skip_regex'     : [],
      \   'skip_regex_head': [],
      \   'skip_regex_tail': [],
      \   'quoteescape'    : 0,
      \   'expand_range'   : -1,
      \   'nesting'        : 0,
      \   'synchro'        : 1,
      \   'noremap'        : 1,
      \   'syntax'         : [],
      \   'inner_syntax'   : [],
      \   'match_syntax'   : 0,
      \   'skip_break'     : 0,
      \   'skip_expr'      : [],
      \ }
let s:default_opt.query = {
      \   'expr'           : 0,
      \   'regex'          : 0,
      \   'skip_regex'     : [],
      \   'skip_regex_head': [],
      \   'skip_regex_tail': [],
      \   'quoteescape'    : 0,
      \   'expand_range'   : -1,
      \   'nesting'        : 0,
      \   'synchro'        : 1,
      \   'noremap'        : 1,
      \   'syntax'         : [],
      \   'inner_syntax'   : [],
      \   'match_syntax'   : 0,
      \   'skip_break'     : 0,
      \   'skip_expr'      : [],
      \ }
let s:default_opt.filter = printf('v:key =~# ''\%%(%s\)''', join(keys(s:default_opt['auto']), '\|'))


function! s:initialize_options(...) abort  "{{{
  let manner = a:0 ? a:1 : 'keep'
  let g:textobj#sandwich#options = s:get('options', {})
  for kind in ['auto', 'query']
    if !has_key(g:textobj#sandwich#options, kind)
      let g:textobj#sandwich#options[kind] = {}
    endif
    call extend(g:textobj#sandwich#options[kind],
          \ deepcopy(s:default_opt[kind]), manner)
  endfor
endfunction
call s:initialize_options()
"}}}
function! textobj#sandwich#set_default() abort  "{{{
  call s:initialize_options('force')
endfunction
"}}}
function! textobj#sandwich#set(kind, option, value) abort "{{{
  if s:argument_error(a:kind, a:option, a:value)
    return
  endif

  if a:kind ==# 'all'
    let kinds = ['auto', 'query']
  else
    let kinds = [a:kind]
  endif

  for kind in kinds
    let g:textobj#sandwich#options[kind][a:option] = a:value
  endfor
endfunction
"}}}
function! textobj#sandwich#setlocal(kind, option, value) abort "{{{
  if s:argument_error(a:kind, a:option, a:value)
    return
  endif

  if !exists('b:textobj_sandwich_options')
    let b:textobj_sandwich_options = deepcopy(g:textobj#sandwich#options)
  endif

  if a:kind ==# 'all'
    let kinds = ['auto', 'query']
  else
    let kinds = [a:kind]
  endif

  for kind in kinds
    let b:textobj_sandwich_options[kind][a:option] = a:value
  endfor
endfunction
"}}}
function! s:argument_error(kind, option, value) abort "{{{
  if !(a:kind ==# 'auto' || a:kind ==# 'query' || a:kind ==# 'all')
    echohl WarningMsg
    echomsg 'Invalid kind "' . a:kind . '".'
    echohl NONE
    return 1
  endif

  " NOTE: Regaardless of a:kind, keys(s:default_opt[a:kind]) is fixed since
  "       the two textobjects have same kinds of options.
  if filter(keys(s:default_opt['auto']), 'v:val ==# a:option') == []
    echohl WarningMsg
    echomsg 'Invalid option name "' . a:kind . '".'
    echohl NONE
    return 1
  endif

  if type(a:value) != type(s:default_opt['auto'][a:option])
    echohl WarningMsg
    echomsg 'Invalid type of value. ' . string(a:value)
    echohl NONE
    return 1
  endif
  return 0
endfunction
"}}}
"}}}

unlet! g:textobj#sandwich#object


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
