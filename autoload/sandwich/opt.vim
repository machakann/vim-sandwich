" opt object - managing options

function! sandwich#opt#new(kind, defaultopt, argopt) abort  "{{{
  let opt = deepcopy(s:opt)
  if a:kind ==# 'auto' || a:kind ==# 'query'
    let opt.recipe = {}
    let opt.of = function('s:of_for_textobj')
    let opt.filter = s:default_values['textobj']['filter']
    call opt.update('arg', a:argopt)
    call opt.update('default', a:defaultopt)
  else
    let opt.recipe_add = {}
    let opt.recipe_delete = {}
    let opt.of = function('s:of_for_' . a:kind)
    let opt.filter = s:default_values[a:kind]['filter']
    call opt.update('arg', a:argopt)
  endif
  return opt
endfunction
"}}}
function! sandwich#opt#defaults(kind, ...) abort "{{{
  if a:kind ==# 'auto' || a:kind ==# 'query'
    return deepcopy(s:default_values['textobj'][a:kind])
  elseif a:kind ==# 'add' || a:kind ==# 'delete' || a:kind ==# 'replace'
    let motionwise = get(a:000, 0, 'char')
    return deepcopy(s:default_values[a:kind][motionwise])
  else
    return {}
  endif
endfunction
"}}}

" opt "{{{
let s:opt = {
      \   'default' : {},
      \   'arg'     : {},
      \   'filter'  : '',
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
    elseif a:opt_name ==# 'hi_duration'
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
function! s:of_for_textobj(opt_name) dict abort  "{{{
  if has_key(self['recipe'], a:opt_name)
    return self['recipe'][a:opt_name]
  elseif has_key(self['arg'], a:opt_name)
    return self['arg'][a:opt_name]
  else
    return self['default'][a:opt_name]
  endif
endfunction
"}}}

" default values "{{{
let s:default_values = {}
let s:default_values.add = {}
let s:default_values.add.char = {
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
let s:default_values.add.line = {
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
let s:default_values.add.block = {
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
let s:default_values.add.filter = printf('v:key =~# ''\%%(%s\)''', join(keys(s:default_values['add']['char']), '\|'))

let s:default_values.delete = {}
let s:default_values.delete.char = {
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
let s:default_values.delete.line = {
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
let s:default_values.delete.block = {
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
let s:default_values.delete.filter = printf('v:key =~# ''\%%(%s\)''', join(keys(s:default_values['delete']['char']), '\|'))

let s:default_values.replace = {}
let s:default_values.replace.char = {
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
let s:default_values.replace.line = {
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
let s:default_values.replace.block = {
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
let s:default_values.replace.filter = printf('v:key =~# ''\%%(%s\)''', join(keys(s:default_values['replace']['char']), '\|'))

let s:default_values.textobj = {}
let s:default_values.textobj.auto = {
      \   'expr'           : 0,
      \   'listexpr'       : 0,
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
let s:default_values.textobj.query = {
      \   'expr'           : 0,
      \   'listexpr'       : 0,
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
let s:default_values.textobj.filter = printf('v:key =~# ''\%%(%s\)''', join(keys(s:default_values.textobj.auto), '\|'))
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
