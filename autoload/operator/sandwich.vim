" operator-sandwich: wrap by buns!
" TODO Give API to get information from operator object.
"      It would be helpful for users in use of 'expr_filter' and 'command' option.
" TODO Add 'at' option

" variables "{{{
let s:constants = function('sandwich#constants#get')

" patchs
if v:version > 704 || (v:version == 704 && has('patch237'))
  let s:has_patch_7_4_392 = has('patch-7.4.392')
else
  let s:has_patch_7_4_392 = v:version == 704 && has('patch392')
endif

" Others
" NOTE: This would be updated in each operator functions (operator#sandwich#{add/delete/replce})
let s:is_in_cmdline_window = 0
" Current set operator
let s:operator = ''
"}}}
" highlight {{{
function! s:default_highlight() abort
  highlight default link OperatorSandwichBuns   IncSearch
  highlight default link OperatorSandwichAdd    DiffAdd
  highlight default link OperatorSandwichDelete DiffDelete

  if hlexists('OperatorSandwichStuff')
    highlight default link OperatorSandwichChange OperatorSandwichStuff
  else
    " obsolete
    highlight default link OperatorSandwichChange DiffChange
  endif
endfunction
call s:default_highlight()

augroup sandwich-event-ColorScheme
  autocmd!
  autocmd ColorScheme * call s:default_highlight()
augroup END
"}}}

""" Public functions
" Prerequisite
function! operator#sandwich#prerequisite(kind, mode, ...) abort "{{{
  " make new operator object
  let g:operator#sandwich#object = operator#sandwich#operator#new()

  " prerequisite
  let operator = g:operator#sandwich#object
  let operator.state = 1
  let operator.kind = a:kind
  let operator.count = a:mode ==# 'x' ? max([1, v:prevcount]) : v:count1
  let operator.mode = a:mode
  let operator.view = winsaveview()
  let operator.cursor.keepable = 1
  let operator.cursor.keep[0:3] = getpos('.')[0:3]
  let operator.opt = sandwich#opt#new(a:kind, {}, get(a:000, 0, {}))
  let operator.recipes.arg = get(a:000, 1, [])
  let operator.recipes.arg_given = a:0 > 1

  let [operator.extended, operator.blockwidth] = s:blockwisevisual_info(a:mode)

  let &l:operatorfunc = 'operator#sandwich#' . a:kind
  let s:operator = a:kind
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
  call feedkeys(cmd, 'inx')
  return
endfunction
"}}}
function! s:blockwisevisual_info(mode) abort  "{{{
  if a:mode ==# 'x' && visualmode() ==# "\<C-v>"
    " The case for blockwise selections in visual mode
    " NOTE: 'extended' could be recorded safely only at here. Do not move.
    let registers = s:saveregisters()
    let lazyredraw = &lazyredraw
    set lazyredraw
    let view = winsaveview()
    try
      normal! gv
      let extended = winsaveview().curswant == s:constants('colmax')
      silent noautocmd normal! ""y
      let regtype = getregtype('"')
    finally
      call winrestview(view)
      let &lazyredraw = lazyredraw
      call s:restoreregisters(registers)
    endtry
    let blockwidth = str2nr(regtype[1:])
  else
    let extended   = 0
    let blockwidth = 0
  endif
  return [extended, blockwidth]
endfunction
"}}}
function! s:saveregisters() abort "{{{
  let registers = {}
  let registers['0'] = s:getregister('0')
  let registers['"'] = s:getregister('"')
  return registers
endfunction
"}}}
function! s:restoreregisters(registers) abort "{{{
  for [register, contains] in items(a:registers)
    call s:setregister(register, contains)
  endfor
endfunction
"}}}
function! s:getregister(register) abort "{{{
  return [getreg(a:register), getregtype(a:register)]
endfunction
"}}}
function! s:setregister(register, contains) abort "{{{
  let [value, options] = a:contains
  return setreg(a:register, value, options)
endfunction
"}}}

" Operator functions
function! operator#sandwich#add(motionwise, ...) abort  "{{{
  call s:do('add', a:motionwise, 'OperatorSandwichAddPre', 'OperatorSandwichAddPost')
endfunction
"}}}
function! operator#sandwich#delete(motionwise, ...) abort  "{{{
  call s:do('delete', a:motionwise, 'OperatorSandwichDeletePre', 'OperatorSandwichDeletePost')
endfunction
"}}}
function! operator#sandwich#replace(motionwise, ...) abort  "{{{
  call s:do('replace', a:motionwise, 'OperatorSandwichReplacePre', 'OperatorSandwichReplacePost')
endfunction
"}}}
function! s:do(kind, motionwise, AutocmdPre, AutocmdPost) abort "{{{
  let s:operator = ''
  if exists('g:operator#sandwich#object')
    let operator = g:operator#sandwich#object
    let messenger = sandwich#messenger#new()
    let defaultopt = s:default_options(a:kind, a:motionwise)
    call operator.opt.update('default', defaultopt)
    call s:update_is_in_cmdline_window()
    call s:doautocmd(a:AutocmdPre)
    call operator.execute(a:motionwise)
    call s:doautocmd(a:AutocmdPost)
    call messenger.notify('operator-sandwich: ')
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
    if exists('#User#' . a:name)
      execute 'doautocmd <nomodeline> User ' . a:name
    endif
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
  call stuff.initialize(operator.count, operator.cursor, operator.modmark)
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
    let cmd = a:mode ==# 'x'
          \ ? "\<Plug>(operator-sandwich-gv)\<Plug>(operator-sandwich-g@)"
          \ : "\<Plug>(operator-sandwich-g@)"
    call feedkeys(cmd, 'im')
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

" visualrepeat.vim (vimscript #3848) support
function! operator#sandwich#visualrepeat(kind) abort  "{{{
  let operator = g:operator#sandwich#object

  let original_mode = operator.mode
  let original_extended = operator.extended
  let original_blockwidth = operator.blockwidth

  let operator.mode = 'x'
  let [operator.extended, operator.blockwidth] = s:blockwisevisual_info('x')
  try
    normal! gv
    let operator.cursor.keepable = 1
    let operator.cursor.keep[0:3] = getpos('.')[0:3]

    let l:count = v:count ? v:count : ''
    let &l:operatorfunc = 'operator#sandwich#' . a:kind
    let cmd = printf("normal! %sg@", l:count)
    execute cmd
  finally
    let operator.mode = original_mode
    let operator.extended = original_extended
    let operator.blockwidth = original_blockwidth
  endtry
endfunction
"}}}

" API
function! operator#sandwich#show(...) abort  "{{{
  if !exists('g:operator#sandwich#object') || !g:operator#sandwich#object.at_work
    echoerr 'operator-sandwich: Not in an operator-sandwich operation!'
    return 1
  endif

  let operator = g:operator#sandwich#object
  let kind = operator.kind
  let opt  = operator.opt
  let place = get(a:000, 0, '')
  if kind ==# 'add'
    if place ==# ''
      let place = 'stuff'
    endif
    if place ==# 'added'
      let hi_group = s:get_ifnotempty(a:000, 1, 'OperatorSandwichAdd')
    else
      let hi_group = opt.of('highlight') >= 2
                  \ ? s:get_ifnotempty(a:000, 1, 'OperatorSandwichChange')
                  \ : s:get_ifnotempty(a:000, 1, 'OperatorSandwichBuns')
    endif
  elseif kind ==# 'delete'
    if place ==# ''
      let place = 'target'
    endif
    let hi_group = opt.of('highlight') >= 2
                \ ? s:get_ifnotempty(a:000, 1, 'OperatorSandwichDelete')
                \ : s:get_ifnotempty(a:000, 1, 'OperatorSandwichBuns')
  elseif kind ==# 'replace'
    if place ==# ''
      let place = 'target'
    endif
    if place ==# 'added'
      let hi_group = s:get_ifnotempty(a:000, 1, 'OperatorSandwichAdd')
    elseif place ==# 'target'
      let hi_group = opt.of('highlight') >= 2
                  \ ? s:get_ifnotempty(a:000, 1, 'OperatorSandwichDelete')
                  \ : s:get_ifnotempty(a:000, 1, 'OperatorSandwichBuns')
    else
      let hi_group = opt.of('highlight') >= 2
                  \ ? s:get_ifnotempty(a:000, 1, 'OperatorSandwichChange')
                  \ : s:get_ifnotempty(a:000, 1, 'OperatorSandwichBuns')
    endif
  else
    return 1
  endif
  let forcibly = get(a:000, 2, 0)
  return operator.show(place, hi_group, forcibly)
endfunction
"}}}
function! operator#sandwich#quench(...) abort  "{{{
  if exists('g:operator#sandwich#object')
    let operator = g:operator#sandwich#object
    let kind = operator.kind
    let place = get(a:000, 0, '')
    if place ==# ''
      if kind ==# 'add'
        let place = 'stuff'
      elseif kind ==# 'delete'
        let place = 'target'
      elseif kind ==# 'replace'
        let place = 'target'
      else
        return 1
      endif
    endif
    return operator.quench(place)
  endif
endfunction
"}}}
function! operator#sandwich#get_info(...) abort  "{{{
  if !exists('g:operator#sandwich#object') || !g:operator#sandwich#object.at_work
    echoerr 'operator-sandwich: Not in an operator-sandwich operation!'
    return 1
  endif

  let info = get(a:000, 0, '')
  if a:0 == 0 || info ==# ''
    return g:operator#sandwich#object
  elseif info ==# 'state' || info ==# 'kind' || info ==# 'count' || info ==# 'mode' || info ==# 'motionwise'
    return g:operator#sandwich#object[info]
  else
    echoerr printf('operator-sandwich: Identifier "%s" is not supported.', string(info))
    return 1
  endif
endfunction
"}}}
function! operator#sandwich#kind() abort  "{{{
  return exists('g:operator#sandwich#object') && g:operator#sandwich#object.at_work
        \ ? g:operator#sandwich#object.kind
        \ : s:operator
endfunction
"}}}
function! s:get_ifnotempty(list, idx, default) abort "{{{
  let item = get(a:list, a:idx, '')
  if item ==# ''
    let item = a:default
  endif
  return item
endfunction
"}}}

" For internal communication
function! operator#sandwich#is_in_cmd_window() abort  "{{{
  return s:is_in_cmdline_window
endfunction
"}}}
function! operator#sandwich#synchronize(kind, recipe) abort "{{{
  if exists('g:operator#sandwich#object') && !empty(a:recipe)
    let g:operator#sandwich#object.recipes.synchro.on = 1
    let g:operator#sandwich#object.recipes.synchro.kind = a:kind
    let g:operator#sandwich#object.recipes.synchro.recipe = [a:recipe]
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
let g:operator#sandwich#default_recipes = []
lockvar! g:operator#sandwich#default_recipes
"}}}

" options "{{{
function! s:default_options(kind, motionwise) abort "{{{
  return get(b:, 'operator_sandwich_options', g:operator#sandwich#options)[a:kind][a:motionwise]
endfunction
"}}}
function! s:initialize_options(...) abort  "{{{
  let manner = a:0 ? a:1 : 'keep'
  let g:operator#sandwich#options = get(g:, 'operator#sandwich#options', {})
  for kind in ['add', 'delete', 'replace']
    if !has_key(g:operator#sandwich#options, kind)
      let g:operator#sandwich#options[kind] = {}
    endif
    for motionwise in ['char', 'line', 'block']
      if !has_key(g:operator#sandwich#options[kind], motionwise)
        let g:operator#sandwich#options[kind][motionwise] = {}
      endif
      call extend(g:operator#sandwich#options[kind][motionwise],
            \ sandwich#opt#defaults(kind, motionwise), manner)
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
    let defaults = sandwich#opt#defaults(a:kind, a:motionwise)
    if filter(keys(defaults), 'v:val ==# a:option') == []
      echohl WarningMsg
      echomsg 'Invalid option name "' . a:option . '".'
      echohl NONE
      return 1
    endif

    if a:option !~# 'indentkeys[-+]\?' && type(a:value) != type(defaults[a:option])
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
      let defaults = sandwich#opt#defaults(kind, motionwise)
      if filter(keys(defaults), 'v:val ==# a:option') != []
        if a:option =~# 'indentkeys[-+]\?' || type(a:value) == type(defaults[a:option])
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
