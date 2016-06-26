" operator-sandwich: wrap by buns!
" TODO Give API to get information from operator object.
"      It would be helpful for users in use of 'expr_filter' and 'command' option.
" TODO Add 'at' option

" variables "{{{
" patchs
if v:version > 704 || (v:version == 704 && has('patch237'))
  let s:has_patch_7_4_392 = has('patch-7.4.392')
else
  let s:has_patch_7_4_392 = v:version == 704 && has('patch392')
endif

" Others
" NOTE: This would be updated in each operator functions (operator#sandwich#{add/delete/replce})
let s:is_in_cmdline_window = 0
"}}}

""" Public functions
" Prerequisite
function! operator#sandwich#prerequisite(kind, mode, ...) abort "{{{
  " make new operator object
  let g:operator#sandwich#object = operator#sandwich#operator#new()

  " prerequisite
  let operator = g:operator#sandwich#object
  let operator.state = 1
  let operator.kind  = a:kind
  let operator.count = a:mode ==# 'x' ? max([1, v:prevcount]) : v:count1
  let operator.mode  = a:mode
  let operator.view  = winsaveview()
  let operator.cursor.keepable = 1
  let operator.cursor.keep[0:3] = getpos('.')[0:3]
  let operator.opt = sandwich#opt#new(a:kind)
  let operator.opt.filter = s:default_opt[a:kind]['filter']
  call operator.opt.update('arg', get(a:000, 0, {}))
  let operator.recipes.arg = get(a:000, 1, [])
  let operator.recipes.arg_given = a:0 > 1

  if a:mode ==# 'x' && visualmode() ==# "\<C-v>"
    " The case for blockwise selections in visual mode
    " NOTE: 'is_extended' could be recorded safely only at here. Do not move.
    let reg = ['"', getreg('"'), getregtype('"')]
    try
      normal! gv
      let is_extended = winsaveview().curswant == 1/0
      silent normal! ""y
      let regtype = getregtype('"')
    finally
      call call('setreg', reg)
    endtry

    let operator.extended   = is_extended
    let operator.blockwidth = str2nr(regtype[1:])
  else
    let operator.extended   = 0
    let operator.blockwidth = 0
  endif

  let &l:operatorfunc = 'operator#sandwich#' . a:kind
  return
endfunction
"}}}
function! operator#sandwich#keymap(kind, mode, ...) abort "{{{
  if a:0 == 0
    call operator#sandwich#prerequisite(a:kind, a:mode)
  elseif a:0 == 1
    call operator#sandwich#prerequisite(a:kind, a:mode, a:1)
  else
    call operator#sandwich#prerequisite(a:kind, a:mode, a:1, a:2)
  endif

  let cmd = a:mode ==# 'x' ? 'gvg@' : 'g@'
  call feedkeys(cmd, 'n')
  return
endfunction
"}}}

" Operator functions
function! operator#sandwich#add(motionwise, ...) abort  "{{{
  if exists('g:operator#sandwich#object')
    call s:update_is_in_cmdline_window()
    call s:doautocmd('OperatorSandwichAddPre')
    let message = g:operator#sandwich#object.execute(a:motionwise)
    call s:doautocmd('OperatorSandwichAddPost')
    call message.notify('operator-sandwich: ')
  endif
endfunction
"}}}
function! operator#sandwich#delete(motionwise, ...) abort  "{{{
  if exists('g:operator#sandwich#object')
    call s:update_is_in_cmdline_window()
    call s:doautocmd('OperatorSandwichDeletePre')
    let message = g:operator#sandwich#object.execute(a:motionwise)
    call s:doautocmd('OperatorSandwichDeletePost')
    call message.notify('operator-sandwich: ')
  endif
endfunction
"}}}
function! operator#sandwich#replace(motionwise, ...) abort  "{{{
  if exists('g:operator#sandwich#object')
    call s:update_is_in_cmdline_window()
    call s:doautocmd('OperatorSandwichReplacePre')
    let message = g:operator#sandwich#object.execute(a:motionwise)
    call s:doautocmd('OperatorSandwichReplacePost')
    call message.notify('operator-sandwich: ')
  endif
endfunction
"}}}
" function! s:update_is_in_cmdline_window() abort  "{{{
if s:has_patch_7_4_392
  function! s:update_is_in_cmdline_window() abort
    let s:is_in_cmdline_window = getcmdwintype() !=# ''
  endfunction
else
  function! s:update_is_in_cmdline_window() abort
    let s:is_in_cmdline_window = 0
    try
      execute 'tabnext ' . tabpagenr()
    catch /^Vim\%((\a\+)\)\=:E11/
      let s:is_in_cmdline_window = 1
    catch
    endtry
  endfunction
endif
"}}}
function! s:doautocmd(name) abort "{{{
  let view = s:saveview()
  try
    execute 'silent doautocmd <nomodeline> User ' . a:name
  catch
    let errormsg = printf('operator-sandwich: An error occurred in autocmd %s. [%s]', a:name, v:exception)
    echoerr errormsg
  finally
    call s:restview(view, a:name)
  endtry
endfunction
"}}}
function! s:saveview() abort  "{{{
  return [tabpagenr(), winnr(), winsaveview(), getpos("'["), getpos("']")]
endfunction
"}}}
function! s:restview(view, name) abort  "{{{
  let [tabpagenr, winnr, view, modhead, modtail] = a:view

  if s:is_in_cmdline_window
    " in cmdline-window
    return
  endif

  " tabpage
  try
    execute 'tabnext ' . tabpagenr
    if tabpagenr() != tabpagenr
      throw 'OperatorSandwichError:CouldNotRestoreTabpage'
    endif
  catch /^OperatorSandwichError:CouldNotRestoreTabpage/
    let errormsg = printf('operator-sandwich: Could not have restored tabpage after autocmd %s.', a:name)
    echoerr errormsg
  endtry

  " window
  try
    execute winnr . 'wincmd w'
  catch /^Vim\%((\a\+)\)\=:E16/
    let errormsg = printf('operator-sandwich: Could not have restored window after autocmd %s.', a:name)
    echoerr errormsg
  endtry
  " view
  call winrestview(view)
  " marks
  call setpos("'[", modhead)
  call setpos("']", modtail)
endfunction
"}}}

" For the query1st series mappings
function! operator#sandwich#query1st(kind, mode, ...) abort "{{{
  if a:kind !=# 'add' && a:kind !=# 'replace'
    return
  endif

  " prerequisite
  let arg_opt = get(a:000, 0, {})
  let arg_recipes = get(a:000, 1, [])
  call operator#sandwich#prerequisite(a:kind, a:mode, arg_opt, arg_recipes)
  let operator = g:operator#sandwich#object
  " NOTE: force to set highlight=0 and query_once=1
  call operator.opt.update('default', {'highlight': 0, 'query_once': 1, 'expr': 0, 'listexpr': 0})
  let operator.recipes.arg_given = a:0 > 1

  let stuff = operator#sandwich#stuff#new()
  call stuff.initialize(operator.count, operator.cursor, operator.modmark, operator.message)
  let operator.basket = [stuff]

  " pick 'recipe' up and query prefered buns
  call operator.recipes.integrate(a:kind, 'all', a:mode)
  for i in range(operator.count)
    let opt = operator.opt
    let recipe = operator.query()
    let operator.recipes.dog_ear += [recipe]
    if !has_key(recipe, 'buns') || recipe.buns == []
      break
    endif

    call opt.update('recipe_add', recipe)
    if i == 0 && operator.count > 1 && opt.of('query_once')
      call operator.recipes.fill(recipe, operator.count)
      break
    endif
  endfor

  if filter(copy(operator.recipes.dog_ear), 'has_key(v:val, "buns")') != []
    let operator.state = 0
    let cmd = a:mode ==# 'x' ? 'gvg@' : 'g@'
    call feedkeys(cmd, 'n')
  else
    unlet g:operator#sandwich#object
  endif
  return
endfunction
"}}}

" Supplementary keymappings
function! operator#sandwich#synchro_count() abort  "{{{
  if exists('g:operator#sandwich#object')
    return g:operator#sandwich#object.count
  else
    return ''
  endif
endfunction
"}}}
function! operator#sandwich#release_count() abort  "{{{
  if exists('g:operator#sandwich#object')
    let l:count = g:operator#sandwich#object.count
    let g:operator#sandwich#object.count = 1
    return l:count
  else
    return ''
  endif
endfunction
"}}}
function! operator#sandwich#squash_count() abort  "{{{
  if exists('g:operator#sandwich#object')
    let g:operator#sandwich#object.count = 1
  endif
  return ''
endfunction
"}}}
function! operator#sandwich#predot() abort  "{{{
  if exists('g:operator#sandwich#object')
    let operator = g:operator#sandwich#object
    let operator.cursor.keepable = 1
    let operator.cursor.keep[0:3] = getpos('.')[0:3]
  endif
  return ''
endfunction
"}}}
function! operator#sandwich#dot() abort  "{{{
  call operator#sandwich#predot()
  return '.'
endfunction
"}}}

" API
function! operator#sandwich#show(place, ...) abort  "{{{
  if !exists('g:operator#sandwich#object') || !g:operator#sandwich#object.at_work
    echoerr 'operator-sandwich: Not in an operator-sandwich operation!'
    return 1
  endif

  let operator = g:operator#sandwich#object
  let kind = operator.kind
  let opt  = operator.opt
  if kind ==# 'add'
    if a:place ==# 'added'
      let hi_group = get(a:000, 0, 'OperatorSandwichAdd')
    else
      let hi_group = opt.of('highlight') >= 2
                  \ ? get(a:000, 0, 'OperatorSandwichStuff')
                  \ : get(a:000, 0, 'OperatorSandwichBuns')
    endif
  elseif kind ==# 'delete'
    let hi_group = opt.of('highlight') >= 2
                \ ? get(a:000, 0, 'OperatorSandwichDelete')
                \ : get(a:000, 0, 'OperatorSandwichBuns')
  elseif kind ==# 'replace'
    if a:place ==# 'added'
      let hi_group = get(a:000, 0, 'OperatorSandwichAdd')
    elseif a:place ==# 'target'
      let hi_group = opt.of('highlight') >= 2
                  \ ? get(a:000, 0, 'OperatorSandwichDelete')
                  \ : get(a:000, 0, 'OperatorSandwichBuns')
    else
      let hi_group = opt.of('highlight') >= 2
                  \ ? get(a:000, 0, 'OperatorSandwichStuff')
                  \ : get(a:000, 0, 'OperatorSandwichBuns')
    endif
  else
    return 1
  endif
  return operator.show(a:place, hi_group, opt.of('linewise'), 1)
endfunction
"}}}
function! operator#sandwich#quench(place) abort  "{{{
  if exists('g:operator#sandwich#object')
    let operator = g:operator#sandwich#object
    return operator.quench(a:place, 1)
  endif
endfunction
"}}}

" For internal communication
function! operator#sandwich#is_in_cmd_window() abort  "{{{
  return s:is_in_cmdline_window
endfunction
"}}}
function! operator#sandwich#synchronize(recipe) abort "{{{
  if exists('g:operator#sandwich#object') && !empty(a:recipe)
    let g:operator#sandwich#object.recipes.synchro = [a:recipe]
  endif
endfunction
"}}}

" recipes "{{{
function! operator#sandwich#get_recipes() abort  "{{{
  if exists('b:operator_sandwich_recipes')
    let recipes = b:operator_sandwich_recipes
  elseif exists('g:operator#sandwich#recipes')
    let recipes = g:operator#sandwich#recipes
  else
    let recipes = g:operator#sandwich#default_recipes
  endif
  return deepcopy(recipes)
endfunction
"}}}
if exists('g:operator#sandwich#default_recipes')
  unlockvar! g:operator#sandwich#default_recipes
endif
let g:operator#sandwich#default_recipes = [
      \   {'buns': ['input("operator-sandwich:head: ")', 'input("operator-sandwich:tail: ")'], 'kind': ['add', 'replace'], 'action': ['add'], 'expr': 1, 'input': ['i']},
      \ ]
lockvar! g:operator#sandwich#default_recipes
"}}}

" options "{{{
let s:default_opt = {}

let s:default_opt.add = {}
let s:default_opt.add.char = {
      \   'cursor'     : 'default',
      \   'query_once' : 0,
      \   'expr'       : 0,
      \   'listexpr'   : 0,
      \   'noremap'    : 1,
      \   'skip_space' : 0,
      \   'highlight'  : 3,
      \   'hi_duration': 200,
      \   'command'    : [],
      \   'linewise'   : 0,
      \   'autoindent' : -1,
      \   'indentkeys' : 0,
      \   'indentkeys+': 0,
      \   'indentkeys-': 0,
      \ }
let s:default_opt.add.line = {
      \   'cursor'     : 'default',
      \   'query_once' : 0,
      \   'expr'       : 0,
      \   'listexpr'   : 0,
      \   'noremap'    : 1,
      \   'skip_space' : 1,
      \   'highlight'  : 3,
      \   'hi_duration': 200,
      \   'command'    : [],
      \   'linewise'   : 1,
      \   'autoindent' : -1,
      \   'indentkeys' : 0,
      \   'indentkeys+': 0,
      \   'indentkeys-': 0,
      \ }
let s:default_opt.add.block = {
      \   'cursor'     : 'default',
      \   'query_once' : 0,
      \   'expr'       : 0,
      \   'listexpr'   : 0,
      \   'noremap'    : 1,
      \   'skip_space' : 1,
      \   'highlight'  : 3,
      \   'hi_duration': 200,
      \   'command'    : [],
      \   'linewise'   : 0,
      \   'autoindent' : -1,
      \   'indentkeys' : 0,
      \   'indentkeys+': 0,
      \   'indentkeys-': 0,
      \ }
let s:default_opt.add.filter = printf('v:key =~# ''\%%(%s\)''', join(keys(s:default_opt['add']['char']), '\|'))

let s:default_opt.delete = {}
let s:default_opt.delete.char = {
      \   'cursor'     : 'default',
      \   'noremap'    : 1,
      \   'regex'      : 0,
      \   'skip_space' : 1,
      \   'skip_char'  : 0,
      \   'highlight'  : 3,
      \   'hi_duration': 200,
      \   'command'    : [],
      \   'linewise'   : 0,
      \ }
let s:default_opt.delete.line = {
      \   'cursor'     : 'default',
      \   'noremap'    : 1,
      \   'regex'      : 0,
      \   'skip_space' : 2,
      \   'skip_char'  : 0,
      \   'highlight'  : 3,
      \   'hi_duration': 200,
      \   'command'    : [],
      \   'linewise'   : 1,
      \ }
let s:default_opt.delete.block = {
      \   'cursor'     : 'default',
      \   'noremap'    : 1,
      \   'regex'      : 0,
      \   'skip_space' : 1,
      \   'skip_char'  : 0,
      \   'highlight'  : 3,
      \   'hi_duration': 200,
      \   'command'    : [],
      \   'linewise'   : 0,
      \ }
let s:default_opt.delete.filter = printf('v:key =~# ''\%%(%s\)''', join(keys(s:default_opt['delete']['char']), '\|'))

let s:default_opt.replace = {}
let s:default_opt.replace.char = {
      \   'cursor'     : 'default',
      \   'query_once' : 0,
      \   'regex'      : 0,
      \   'expr'       : 0,
      \   'listexpr'   : 0,
      \   'noremap'    : 1,
      \   'skip_space' : 1,
      \   'skip_char'  : 0,
      \   'highlight'  : 3,
      \   'hi_duration': 200,
      \   'command'    : [],
      \   'linewise'   : 0,
      \   'autoindent' : -1,
      \   'indentkeys' : 0,
      \   'indentkeys+': 0,
      \   'indentkeys-': 0,
      \ }
let s:default_opt.replace.line = {
      \   'cursor'     : 'default',
      \   'query_once' : 0,
      \   'regex'      : 0,
      \   'expr'       : 0,
      \   'listexpr'   : 0,
      \   'noremap'    : 1,
      \   'skip_space' : 2,
      \   'skip_char'  : 0,
      \   'highlight'  : 3,
      \   'hi_duration': 200,
      \   'command'    : [],
      \   'linewise'   : 0,
      \   'autoindent' : -1,
      \   'indentkeys' : 0,
      \   'indentkeys+': 0,
      \   'indentkeys-': 0,
      \ }
let s:default_opt.replace.block = {
      \   'cursor'     : 'default',
      \   'query_once' : 0,
      \   'regex'      : 0,
      \   'expr'       : 0,
      \   'listexpr'   : 0,
      \   'noremap'    : 1,
      \   'skip_space' : 1,
      \   'skip_char'  : 0,
      \   'highlight'  : 3,
      \   'hi_duration': 200,
      \   'command'    : [],
      \   'linewise'   : 0,
      \   'autoindent' : -1,
      \   'indentkeys' : 0,
      \   'indentkeys+': 0,
      \   'indentkeys-': 0,
      \ }
let s:default_opt.replace.filter = printf('v:key =~# ''\%%(%s\)''', join(keys(s:default_opt['replace']['char']), '\|'))

let [s:get] = operator#sandwich#lib#funcref(['get'])
function! s:initialize_options(...) abort  "{{{
  let manner = a:0 ? a:1 : 'keep'
  let g:operator#sandwich#options = s:get('options', {})
  for kind in ['add', 'delete', 'replace']
    if !has_key(g:operator#sandwich#options, kind)
      let g:operator#sandwich#options[kind] = {}
    endif
    for motionwise in ['char', 'line', 'block']
      if !has_key(g:operator#sandwich#options[kind], motionwise)
        let g:operator#sandwich#options[kind][motionwise] = {}
      endif
      call extend(g:operator#sandwich#options[kind][motionwise],
            \ deepcopy(s:default_opt[kind][motionwise]), manner)
    endfor
  endfor
endfunction
call s:initialize_options()
"}}}
function! operator#sandwich#set_default() abort "{{{
  call s:initialize_options('force')
endfunction
"}}}
function! operator#sandwich#set(kind, motionwise, option, value) abort  "{{{
  if s:argument_error(a:kind, a:motionwise, a:option, a:value)
    return
  endif

  if a:kind ==# 'all'
    let kinds = ['add', 'delete', 'replace']
  else
    let kinds = [a:kind]
  endif

  if a:motionwise ==# 'all'
    let motionwises = ['char', 'line', 'block']
  else
    let motionwises = [a:motionwise]
  endif

  call s:set_option_value(g:operator#sandwich#options, kinds, motionwises, a:option, a:value)
endfunction
"}}}
function! operator#sandwich#setlocal(kind, motionwise, option, value) abort  "{{{
  if s:argument_error(a:kind, a:motionwise, a:option, a:value)
    return
  endif

  if !exists('b:operator_sandwich_options')
    let b:operator_sandwich_options = deepcopy(g:operator#sandwich#options)
  endif

  if a:kind ==# 'all'
    let kinds = ['add', 'delete', 'replace']
  else
    let kinds = [a:kind]
  endif

  if a:motionwise ==# 'all'
    let motionwises = ['char', 'line', 'block']
  else
    let motionwises = [a:motionwise]
  endif

  call s:set_option_value(b:operator_sandwich_options, kinds, motionwises, a:option, a:value)
endfunction
"}}}
function! s:argument_error(kind, motionwise, option, value) abort "{{{
  if !(a:kind ==# 'add' || a:kind ==# 'delete' || a:kind ==# 'replace' || a:kind ==# 'all')
    echohl WarningMsg
    echomsg 'Invalid kind "' . a:kind . '".'
    echohl NONE
    return 1
  endif

  if !(a:motionwise ==# 'char' || a:motionwise ==# 'line' || a:motionwise ==# 'block' || a:motionwise ==# 'all')
    echohl WarningMsg
    echomsg 'Invalid motion-wise "' . a:motionwise . '".'
    echohl NONE
    return 1
  endif

  if a:kind !=# 'all' && a:motionwise !=# 'all'
    if filter(keys(s:default_opt[a:kind][a:motionwise]), 'v:val ==# a:option') == []
      echohl WarningMsg
      echomsg 'Invalid option name "' . a:option . '".'
      echohl NONE
      return 1
    endif

    if a:option !~# 'indentkeys[-+]\?' && type(a:value) != type(s:default_opt[a:kind][a:motionwise][a:option])
      echohl WarningMsg
      echomsg 'Invalid type of value. ' . string(a:value)
      echohl NONE
      return 1
    endif
  endif
  return 0
endfunction
"}}}
function! s:set_option_value(dest, kinds, motionwises, option, value) abort  "{{{
  for kind in a:kinds
    for motionwise in a:motionwises
      if filter(keys(s:default_opt[kind][motionwise]), 'v:val ==# a:option') != []
        if a:option =~# 'indentkeys[-+]\?' || type(a:value) == type(s:default_opt[kind][motionwise][a:option])
          let a:dest[kind][motionwise][a:option] = a:value
        endif
      endif
    endfor
  endfor
endfunction
"}}}
"}}}

unlet! g:operator#sandwich#object


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
