" opt object - managing options

function! sandwich#opt#new(kind) abort  "{{{
  let opt = deepcopy(s:opt)
  let opt.of = function('s:of_for_' . a:kind)
  if a:kind ==# 'textobj'
    let opt.recipe = {}
  else
    let opt.recipe_add = {}
    let opt.recipe_delete = {}
  endif
  return opt
endfunction
"}}}

" opt "{{{
let s:opt = {
      \   'default'      : {},
      \   'arg'          : {},
      \   'filter'       : '',
      \ }
"}}}
function! s:opt.clear(target) dict abort "{{{
  call filter(self[a:target], 0)
endfunction
"}}}
function! s:opt.update(target, dict) dict abort "{{{
  call self.clear(a:target)
  call extend(self[a:target], filter(deepcopy(a:dict), self.filter), 'force')
endfunction
"}}}
function! s:opt.has(opt_name) dict abort  "{{{
  return has_key(self.default, a:opt_name)
endfunction
"}}}
function! s:opt.max(opt_name, ...) dict abort "{{{
  let minimum = get(a:000, 0, 0)
  let list = []
  if has_key(self['recipe_delete'], a:opt_name)
    let list += [self['recipe_delete'][a:opt_name]]
  endif
  if has_key(self['recipe_add'], a:opt_name)
    let list += [self['recipe_add'][a:opt_name]]
  endif
  if list == []
    let list += [self._of(a:opt_name)]
  endif
  return max([minimum] + list)
endfunction
"}}}
function! s:opt.get(opt_name, kind, ...) dict abort "{{{
  return self.has(a:opt_name) ? self.of(a:opt_name, a:kind) : get(a:000, 0, 0)
endfunction
"}}}
function! s:opt._of(opt_name, ...) dict abort  "{{{
  let kind = get(a:000, 0, '')
  if kind !=# '' && has_key(self[kind], a:opt_name)
    return self[kind][a:opt_name]
  elseif has_key(self['arg'], a:opt_name)
    return self['arg'][a:opt_name]
  else
    return self['default'][a:opt_name]
  endif
endfunction
"}}}

function! s:of_for_add(opt_name, ...) dict abort  "{{{
  return self._of(a:opt_name, 'recipe_add')
endfunction
"}}}
function! s:of_for_delete(opt_name, ...) dict abort  "{{{
  return self._of(a:opt_name, 'recipe_delete')
endfunction
"}}}
function! s:of_for_replace(opt_name, ...) dict abort  "{{{
  let kind = get(a:000, 0, '')
  if kind !=# ''
    return self._of(a:opt_name, kind)
  else
    if a:opt_name ==# 'cursor'
      " recipe_add > recipe_delete > arg > default
      if has_key(self.recipe_add, a:opt_name)
        return self.recipe_add[a:opt_name]
      else
        return self._of(a:opt_name, 'recipe_delete')
      endif
    elseif a:opt_name ==# 'query_once'
      return self._of(a:opt_name, 'recipe_add')
    elseif a:opt_name ==# 'regex'
      return self._of(a:opt_name, 'recipe_delete')
    elseif a:opt_name ==# 'expr'
      return self._of(a:opt_name, 'recipe_add')
    elseif a:opt_name ==# 'listexpr'
      return self._of(a:opt_name, 'recipe_add')
    elseif a:opt_name ==# 'noremap'
      return self._of(a:opt_name, '')
    elseif a:opt_name ==# 'skip_space'
      return self._of(a:opt_name, 'recipe_delete')
    elseif a:opt_name ==# 'skip_char'
      return self._of(a:opt_name, 'recipe_delete')
    elseif a:opt_name ==# 'highlight'
      return self._of(a:opt_name, '')
    elseif a:opt_name ==# 'command'
      let commands = []
      let commands += get(self.recipe_delete, a:opt_name, [])
      let commands += get(self.recipe_add,    a:opt_name, [])
      if commands == []
        let commands += self._of(a:opt_name)
      endif
      return commands
    elseif a:opt_name ==# 'linewise'
      return self.max(a:opt_name)
    elseif a:opt_name ==# 'autoindent'
      return self._of(a:opt_name, 'recipe_add')
    elseif a:opt_name ==# 'indentkeys'
      return self._of(a:opt_name, 'recipe_add')
    elseif a:opt_name ==# 'indentkeys+'
      return self._of(a:opt_name, 'recipe_add')
    elseif a:opt_name ==# 'indentkeys-'
      return self._of(a:opt_name, 'recipe_add')
    else
      " should not reach here!
      throw 'OperatorSandwichError:Replace:InvalidOption:' . a:opt_name
    endif
  endif
endfunction
"}}}
function! s:of_for_textobj(opt_name, ...) dict abort  "{{{
  if has_key(self['recipe'], a:opt_name)
    return self['recipe'][a:opt_name]
  elseif has_key(self['arg'], a:opt_name)
    return self['arg'][a:opt_name]
  else
    return self['default'][a:opt_name]
  endif
endfunction
"}}}


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
