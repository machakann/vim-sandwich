" textobj-sandwich: pick up a sandwich!
" NOTE: Because of the restriction of vim, if a operator to get the assigned
"       region is employed for 'external' user-defined textobjects, it makes
"       impossible to repeat by dot command. Thus, 'external' is checked by
"       using visual selection xmap in any case.

" variables "{{{
" types
let s:type_str = type('')
let s:type_num = type(0)
"}}}

function! textobj#sandwich#auto(mode, a_or_i, ...) abort  "{{{
  let kind = 'auto'
  let defaultopt = s:default_options(kind)
  let argopt = get(a:000, 0, {})
  let opt = sandwich#opt#new(kind, defaultopt, argopt)
  if a:0 > 1
    let recipes = textobj#sandwich#recipes#new(kind, a:mode, a:2)
  else
    let recipes = textobj#sandwich#recipes#new(kind, a:mode)
  endif
  let textobj = textobj#sandwich#textobj#new(kind, a:a_or_i, a:mode, v:count1, recipes, opt)

  call s:uniq_recipes(textobj.recipes.integrated, opt.of('regex'), opt.of('expr'), opt.of('noremap'))
  if textobj.recipes.integrated != []
    let g:textobj#sandwich#object = textobj
    let cmd = ":\<C-u>call textobj#sandwich#select()\<CR>"
  else
    let cmd = a:mode ==# 'o' ? "\<Esc>" : "\<Plug>(sandwich-nop)"
  endif
  return cmd
endfunction
"}}}
function! textobj#sandwich#query(mode, a_or_i, ...) abort  "{{{
  let kind = 'query'
  let defaultopt = s:default_options(kind)
  let argopt = get(a:000, 0, {})
  let opt = sandwich#opt#new(kind, defaultopt, argopt)
  if a:0 > 1
    let recipes = textobj#sandwich#recipes#new(kind, a:mode, a:2)
  else
    let recipes = textobj#sandwich#recipes#new(kind, a:mode)
  endif
  let textobj = textobj#sandwich#textobj#new(kind, a:a_or_i, a:mode, v:count1, recipes, opt)

  let recipe = s:query(textobj.recipes.integrated, textobj.opt)
  if recipe != {}
    let textobj.recipes.integrated = [recipe]
    let g:textobj#sandwich#object = textobj
    let cmd = ":\<C-u>call textobj#sandwich#select()\<CR>"
  else
    let cmd = a:mode ==# 'o' ? "\<Esc>" : "\<Plug>(sandwich-nop)"
  endif
  return cmd
endfunction
"}}}
function! textobj#sandwich#select() abort  "{{{
  if !exists('g:textobj#sandwich#object')
    return
  endif

  let view = winsaveview()
  let textobj = g:textobj#sandwich#object
  call textobj.initialize()
  let stimeoutlen = max([0, s:get('stimeoutlen', 500)])
  let [virtualedit, whichwrap]   = [&virtualedit, &whichwrap]
  let [&virtualedit, &whichwrap] = ['onemore', 'h,l']
  try
    let candidates = textobj.list(stimeoutlen)
    let elected = textobj.elect(candidates)
    call winrestview(view)
    call textobj.select(elected)
  finally
    let mark_latestjump = s:get('latest_jump', 1)
    call textobj.finalize(mark_latestjump)
    if !textobj.done
      call winrestview(view)
    endif
    let [&virtualedit, &whichwrap] = [virtualedit, whichwrap]
  endtry

  let g:textobj#sandwich#object = textobj " This is required in case that textobj-sandwich call textobj-sandwich itself in its recipe.
endfunction
"}}}

function! s:query(recipes, opt) abort  "{{{
  let recipes = deepcopy(a:recipes)
  let clock   = sandwich#clock#new()
  let timeoutlen = max([0, s:get('timeoutlen', &timeoutlen)])

  let input   = ''
  let last_compl_match = ['', []]
  while 1
    let c = getchar(0)
    if empty(c)
      if clock.started && timeoutlen > 0 && clock.elapsed() > timeoutlen
        let [input, recipes] = last_compl_match
        break
      else
        sleep 20m
        continue
      endif
    endif

    let c = type(c) == s:type_num ? nr2char(c) : c
    let input .= c

    " check forward match
    let n_fwd = len(filter(recipes, 's:is_input_matched(v:val, input, a:opt, 0)'))

    " check complete match
    let n_comp = len(filter(copy(recipes), 's:is_input_matched(v:val, input, a:opt, 1)'))
    if n_comp
      if len(recipes) == n_comp
        break
      else
        call clock.stop()
        call clock.start()
        let last_compl_match = [input, copy(recipes)]
      endif
    else
      if clock.started && !n_fwd
        let [input, recipes] = last_compl_match
        " FIXME: Additional keypress, 'c', is ignored now, but it should be pressed.
        "        The problem is feedkeys() cannot be used for here...
        break
      endif
    endif
    if recipes == [] | break | endif
  endwhile
  call clock.stop()

  if filter(recipes, 's:is_input_matched(v:val, input, a:opt, 1)') != []
    let recipe = recipes[0]
    if !has_key(recipe, 'buns') && !has_key(recipe, 'external')
      let recipe = {}
    endif
  else
    if input ==# "\<Esc>" || input ==# "\<C-c>" || input ==# ''
      let recipe = {}
    else
      let c = split(input, '\zs')[0]
      let recipe = {'buns': [c, c], 'expr': 0, 'regex': 0}
    endif
  endif

  return recipe
endfunction
"}}}
function! s:is_input_matched(candidate, input, opt, flag) abort "{{{
  let has_buns = has_key(a:candidate, 'buns')
  let has_ext  = has_key(a:candidate, 'external') && has_key(a:candidate, 'input')
  if !(has_buns || has_ext)
    return 0
  elseif !a:flag && a:input ==# ''
    return 1
  endif

  let candidate = deepcopy(a:candidate)

  if has_buns
    call a:opt.update('recipe', candidate)

    " 'input' is necessary for 'expr' or 'regex' buns
    if (a:opt.of('expr') || a:opt.of('regex')) && !has_key(candidate, 'input')
      return 0
    endif

    let inputs = copy(get(candidate, 'input', candidate['buns']))
  elseif has_ext
    " 'input' is necessary for 'external' textobjects assignment
    if !has_key(candidate, 'input')
      return 0
    endif

    let inputs = copy(a:candidate['input'])
  endif

  " If a:flag == 0, check forward match. Otherwise, check complete match.
  if a:flag
    return filter(inputs, 'v:val ==# a:input') != []
  else
    let idx = strlen(a:input) - 1
    return filter(inputs, 'v:val[: idx] ==# a:input') != []
  endif
endfunction
"}}}
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
function! s:get(name, default) abort  "{{{
  return get(g:, 'textobj#sandwich#' . a:name, a:default)
endfunction
"}}}

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
let g:textobj#sandwich#default_recipes = []
lockvar! g:textobj#sandwich#default_recipes
"}}}

" option "{{{
function! s:default_options(kind) abort "{{{
  return get(b:, 'textobj_sandwich_options', g:textobj#sandwich#options)[a:kind]
endfunction
"}}}
function! s:initialize_options(...) abort  "{{{
  let manner = a:0 ? a:1 : 'keep'
  let g:textobj#sandwich#options = s:get('options', {})
  for kind in ['auto', 'query']
    if !has_key(g:textobj#sandwich#options, kind)
      let g:textobj#sandwich#options[kind] = {}
    endif
    call extend(g:textobj#sandwich#options[kind],
          \ sandwich#opt#defaults(kind), manner)
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

  " NOTE: Regaardless of a:kind, keys(defaults) is fixed since
  "       the two textobjects have same kinds of options.
  let defaults = sandwich#opt#defaults('auto')
  if filter(keys(defaults), 'v:val ==# a:option') == []
    echohl WarningMsg
    echomsg 'Invalid option name "' . a:kind . '".'
    echohl NONE
    return 1
  endif

  if type(a:value) != type(defaults[a:option])
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
