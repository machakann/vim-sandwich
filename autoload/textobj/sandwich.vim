" textobj-sandwich: pick up a sandwich!

function! textobj#sandwich#auto(mode, a_or_i, ...) abort  "{{{
  let kind = 'auto'
  let defaultopt = s:default_options(kind)
  let argopt = get(a:000, 0, {})
  let opt = sandwich#opt#new(kind, defaultopt, argopt)
  if a:0 >= 2
    let recipes = textobj#sandwich#recipes#new(kind, a:mode, a:2)
  else
    let recipes = textobj#sandwich#recipes#new(kind, a:mode)
  endif
  call recipes.uniq(opt)

  if recipes.integrated != []
    let g:textobj#sandwich#object = textobj#sandwich#textobj#new(
          \ kind, a:a_or_i, a:mode, v:count1, recipes, opt)
    let cmd = ":\<C-u>call textobj#sandwich#select()\<CR>"
  else
    let cmd = a:mode ==# 'o' ? "\<Esc>" : "\<Ignore>"
  endif
  return cmd
endfunction
"}}}
function! textobj#sandwich#query(mode, a_or_i, ...) abort  "{{{
  let kind = 'query'
  let defaultopt = s:default_options(kind)
  let argopt = get(a:000, 0, {})
  let opt = sandwich#opt#new(kind, defaultopt, argopt)
  if a:0 >= 2
    let recipes = textobj#sandwich#recipes#new(kind, a:mode, a:2)
  else
    let recipes = textobj#sandwich#recipes#new(kind, a:mode)
  endif
  let timeout = s:get_sandwich_option('timeout', &timeout)
  let timeoutlen = max([0, s:get_sandwich_option('timeoutlen', &timeoutlen)])
  call recipes.query(opt, timeout, timeoutlen)

  if recipes.integrated != []
    let g:textobj#sandwich#object = textobj#sandwich#textobj#new(
          \ kind, a:a_or_i, a:mode, v:count1, recipes, opt)
    let cmd = ":\<C-u>call textobj#sandwich#select()\<CR>"
  else
    let cmd = a:mode ==# 'o' ? "\<Esc>" : "\<Ignore>"
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
  let stimeoutlen = max([0, s:get_textobj_option('stimeoutlen', 500)])
  let [virtualedit, whichwrap]   = [&virtualedit, &whichwrap]
  let [&virtualedit, &whichwrap] = ['onemore', 'h,l']
  try
    let candidates = textobj.list(stimeoutlen)
    let elected = textobj.elect(candidates)
    call winrestview(view)
    call textobj.select(elected)
  finally
    let mark_latestjump = s:get_textobj_option('latest_jump', 1)
    call textobj.finalize(mark_latestjump)
    if !textobj.done
      call winrestview(view)
    endif
    let [&virtualedit, &whichwrap] = [virtualedit, whichwrap]
  endtry

  let g:textobj#sandwich#object = textobj " This is required in case that textobj-sandwich call textobj-sandwich itself in its recipe.
endfunction
"}}}

function! s:get_sandwich_option(name, default) abort "{{{
  if exists('g:textobj#sandwich#' . a:name)
    return eval('g:textobj#sandwich#' . a:name)
  endif
  if exists('g:sandwich#' . a:name)
    return eval('g:sandwich#' . a:name)
  endif
  return a:default
endfunction
"}}}
function! s:get_textobj_option(name, default) abort  "{{{
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
  let g:textobj#sandwich#options = s:get_textobj_option('options', {})
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
