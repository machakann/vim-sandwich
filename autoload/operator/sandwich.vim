" operator-sandwich: wrap by buns!
" TODO Give API to get information from operator object.
"      It would be helpful for users in use of 'expr_filter' and 'command' option.
" TODO Add 'at' option

" variables "{{{
" null valiables
let s:null_coord = [0, 0]
let s:null_pos   = [0, 0, 0, 0]
let s:null_2pos  = {
      \   'head': copy(s:null_pos),
      \   'tail': copy(s:null_pos),
      \ }
let s:null_4pos  = {
      \   'head1': copy(s:null_pos),
      \   'tail1': copy(s:null_pos),
      \   'head2': copy(s:null_pos),
      \   'tail2': copy(s:null_pos),
      \ }

" types
let s:type_num  = type(0)
let s:type_str  = type('')
let s:type_list = type([])
let s:type_dict = type({})
let s:type_fref = type(function('tr'))

" patchs
if v:version > 704 || (v:version == 704 && has('patch237'))
  let s:has_patch_7_4_771 = has('patch-7.4.771')
  let s:has_patch_7_4_310 = has('patch-7.4.310')
  let s:has_patch_7_4_362 = has('patch-7.4.362')
  let s:has_patch_7_4_358 = has('patch-7.4.358')
  let s:has_patch_7_4_392 = has('patch-7.4.392')
else
  let s:has_patch_7_4_771 = v:version == 704 && has('patch771')
  let s:has_patch_7_4_310 = v:version == 704 && has('patch310')
  let s:has_patch_7_4_362 = v:version == 704 && has('patch362')
  let s:has_patch_7_4_358 = v:version == 704 && has('patch358')
  let s:has_patch_7_4_392 = v:version == 704 && has('patch392')
endif

" features
let s:has_reltime_and_float = has('reltime') && has('float')
let s:has_gui_running = has('gui_running')

" Others
" NOTE: This would be updated in each operator functions (operator#sandwich#{add/delete/replce})
let s:is_in_cmdline_window = 0
"}}}

""" Public funcs
" Prerequisite
function! operator#sandwich#prerequisite(kind, mode, ...) abort "{{{
  " make new operator object
  let g:operator#sandwich#object = deepcopy(s:operator)

  " prerequisite
  let operator = g:operator#sandwich#object
  let operator.state = 1
  let operator.count = a:mode ==# 'x' ? max([1, v:prevcount]) : v:count1
  let operator.mode  = a:mode
  let operator.view  = winsaveview()
  let operator.cursor.keep[0:3] = getpos('.')[0:3]
  let operator.opt.filter = s:default_opt[a:kind]['filter']
  let operator.opt.of = operator.opt._of_for[a:kind]
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

" Operator funcs
function! operator#sandwich#add(motionwise, ...) abort  "{{{
  if exists('g:operator#sandwich#object')
    call s:update_is_in_cmdline_window()
    call s:doautocmd('OperatorSandwichAddPre')
    call g:operator#sandwich#object.execute('add', a:motionwise)
    call s:doautocmd('OperatorSandwichAddPost')
  endif
endfunction
"}}}
function! operator#sandwich#delete(motionwise, ...) abort  "{{{
  if exists('g:operator#sandwich#object')
    call s:update_is_in_cmdline_window()
    call s:doautocmd('OperatorSandwichDeletePre')
    call g:operator#sandwich#object.execute('delete', a:motionwise)
    call s:doautocmd('OperatorSandwichDeletePost')
  endif
endfunction
"}}}
function! operator#sandwich#replace(motionwise, ...) abort  "{{{
  if exists('g:operator#sandwich#object')
    call s:update_is_in_cmdline_window()
    call s:doautocmd('OperatorSandwichReplacePre')
    call g:operator#sandwich#object.execute('replace', a:motionwise)
    call s:doautocmd('OperatorSandwichReplacePost')
  endif
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
  call operator.opt.update('default', {'highlight': 0, 'query_once': 1, 'expr': 0})
  let operator.recipe.arg_given = a:0 > 1

  " build stuff
  let stuff = deepcopy(s:stuff)
  let stuff.acts = [deepcopy(s:act)]

  " put stuffs as needed
  let operator.basket = map(range(operator.count), 'deepcopy(stuff)')

  " connect links
  for stuff in operator.basket
    call stuff.initialize(operator.cursor, operator.modmark, operator.opt)
  endfor

  " pick 'recipe' up and query prefered buns
  call operator.recipes.integrate(a:kind, 'all', a:mode)
  for i in range(operator.count)
    let stuff = operator.basket[i]
    let opt = stuff.opt

    call stuff.query(operator.recipes.integrated)
    if stuff.buns == [] || len(stuff.buns) < 2
      break
    endif

    if opt.of('query_once') && operator.count > 1 && i == 0 && operator.state
      for j in range(1, len(operator.basket) - 1)
        call operator.basket[j].mimic(stuff)
      endfor
      break
    endif
  endfor

  if filter(copy(operator.basket), 'has_key(v:val, "buns")') != []
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
    let operator.keepable = 1
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



""" Objects
" clock object - measuring elapsed time in a operation {{{
function! s:clock_start() dict abort  "{{{
  if self.started
    if self.paused
      let self.losstime += str2float(reltimestr(reltime(self.stoptime)))
      let self.paused = 0
    endif
  else
    if s:has_reltime_and_float
      let self.zerotime = reltime()
      let self.started  = 1
    endif
  endif
endfunction
"}}}
function! s:clock_pause() dict abort "{{{
  let self.stoptime = reltime()
  let self.paused   = 1
endfunction
"}}}
function! s:clock_elapsed() dict abort "{{{
  if self.started
    let total = str2float(reltimestr(reltime(self.zerotime)))
    return floor((total - self.losstime)*1000)
  else
    return 0
  endif
endfunction
"}}}
function! s:clock_stop() dict abort  "{{{
  let self.started  = 0
  let self.paused   = 0
  let self.losstime = 0
endfunction
"}}}
let s:clock = {
      \   'started' : 0,
      \   'paused'  : 0,
      \   'zerotime': reltime(),
      \   'stoptime': reltime(),
      \   'losstime': 0,
      \   'start'   : function('s:clock_start'),
      \   'pause'   : function('s:clock_pause'),
      \   'elapsed' : function('s:clock_elapsed'),
      \   'stop'    : function('s:clock_stop'),
      \ }
"}}}
" opt object - managing options {{{
function! s:opt_clear(target) dict abort "{{{
  call filter(self[a:target], 0)
endfunction
"}}}
function! s:opt_update(target, dict) dict abort "{{{
  call self.clear(a:target)
  call extend(self[a:target], filter(deepcopy(a:dict), self.filter), 'force')
endfunction
"}}}
function! s:opt_has(opt_name) dict abort  "{{{
  return has_key(self.default, a:opt_name)
endfunction
"}}}
function! s:opt_max(opt_name, ...) dict abort "{{{
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
function! s:opt_of_for_add(opt_name, ...) dict abort  "{{{
  return self._of(a:opt_name, 'recipe_add')
endfunction
"}}}
function! s:opt_of_for_delete(opt_name, ...) dict abort  "{{{
  return self._of(a:opt_name, 'recipe_delete')
endfunction
"}}}
function! s:opt_of_for_replace(opt_name, ...) dict abort  "{{{
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
    elseif a:opt_name ==# 'skip_space'
      return self.max(a:opt_name)
    elseif a:opt_name ==# 'skip_char'
      return self._of(a:opt_name, 'recipe_delete')
    elseif a:opt_name ==# 'highlight'
      return self.max(a:opt_name)
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
function! s:opt__of(opt_name, ...) dict abort  "{{{
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
let s:opt = {
      \   'recipe_add'   : {},
      \   'recipe_delete': {},
      \   'default'      : {},
      \   'arg'          : {},
      \   'filter'       : '',
      \   'clear'        : function('s:opt_clear'),
      \   'update'       : function('s:opt_update'),
      \   'has'          : function('s:opt_has'),
      \   'max'          : function('s:opt_max'),
      \   '_of'          : function('s:opt__of'),
      \   '_of_for' : {
      \     'add'    : function('s:opt_of_for_add'),
      \     'delete' : function('s:opt_of_for_delete'),
      \     'replace': function('s:opt_of_for_replace'),
      \   },
      \ }
"}}}
" act object - controlling a line of editing {{{
function! s:act_initialize(cursor, modmark, opt) dict abort  "{{{
  let self.cursor  = a:cursor
  let self.modmark = a:modmark
  let self.opt     = a:opt
endfunction
"}}}
function! s:act_set_target() dict abort  "{{{
  let head = copy(self.region.head)
  let tail = copy(self.region.tail)
  let self.target.head1 = head
  let self.target.tail1 = head
  let self.target.head2 = tail
  let self.target.tail2 = tail
endfunction
"}}}
function! s:act_skip_space() dict abort  "{{{
  if self.opt.of('skip_space')
    call s:skip_space(self.region.head, self.region.tail)
  endif
endfunction
"}}}
function! s:act_match(recipes) dict abort "{{{
  let region = self.region
  let opt    = self.opt
  let region_saved = deepcopy(region)

  if s:is_valid_2pos(region) && s:is_ahead(region.tail, region.head)
    let edge_chars = ['', '']
    if self._match_recipes(a:recipes) || self._match_edges(edge_chars)
      " found!
      return
    else
      let [head_c, tail_c] = edge_chars
      if opt.of('skip_space') && (head_c =~# '\s' || tail_c =~# '\s')
        call self.skip_space()
        if s:is_ahead(region.head, region.tail)
          " invalid region after skip spaces
          return
        else
          if self._match_recipes(a:recipes) || self._match_edges(edge_chars)
            " found
            return
          endif
        endif
      endif
    endif


    " skip characters
    let target_list = []
    for candidate in a:recipes
      call opt.update('recipe_delete', candidate)
      if opt.of('skip_char') && has_key(candidate, 'buns')
        let head = region_saved.head
        let tail = region_saved.tail
        let opt_expr = opt.has('expr') && opt.of('expr', 'recipe_delete')
        let patterns = s:get_patterns(candidate, opt_expr, opt.of('regex'))
        let target_list += [s:search_edges(head, tail, patterns)]
      endif
    endfor
    if filter(target_list, 's:is_valid_4pos(v:val)') != []
      let self.target = s:shortest(target_list)
      return
    endif

    call opt.clear('recipe_delete')
  endif
endfunction
"}}}
function! s:act__match_recipes(recipes, ...) dict abort "{{{
  let opt = self.opt
  let is_space_skipped = get(a:000, 0, 0)

  let found = 0
  for candidate in a:recipes
    call opt.update('recipe_delete', candidate)
    if !is_space_skipped || opt.of('skip_space')
      if has_key(candidate, 'buns')
        " search buns
        let opt_expr = opt.has('expr') && opt.of('expr', 'recipe_delete')
        let patterns = s:get_patterns(candidate, opt_expr, opt.of('regex'))
        let target = s:check_edges(self.region.head, self.region.tail, patterns)
      elseif has_key(candidate, 'external')
        " get difference of external motion/textobject
        let target = s:check_textobj_diff(self.region.head, self.region.tail, candidate, opt.of('noremap', 'recipe_delete'))
      else
        let target = deepcopy(s:null_4pos)
      endif

      if s:is_valid_4pos(target)
        let found = 1
        let self.target = target
        break
      endif
    endif
  endfor
  return found
endfunction
"}}}
function! s:act__match_edges(recipes, edge_chars) dict abort "{{{
  let opt = self.opt
  let head = self.region.head
  let tail = self.region.tail
  let head_c = s:get_cursorchar(head)
  let tail_c = s:get_cursorchar(tail)

  let found = 0
  if head_c ==# tail_c
    " check duplicate with recipe
    for candidate in a:recipes
      call opt.update('recipe_delete', candidate)
      if has_key(candidate, 'buns')
        let opt_expr  = opt.has('expr') && opt.of('expr', 'recipe_delete')
        let opt_regex = opt.of('regex')
        if !opt_expr && !opt_regex
          if candidate.buns == [head_c, tail_c]
            " The pair has already checked by a recipe.
            return 0
          endif
        endif
      endif
    endfor

    " both edges are matched
    call opt.clear('recipe_delete')
    if !(opt.of('skip_space') == 2 && head_c =~# '\s')
      let found = 1
      let self.target = {
            \   'head1': head, 'tail1': head,
            \   'head2': tail, 'tail2': tail,
            \ }
    endif
  endif

  let a:edge_chars[0] = head_c
  let a:edge_chars[1] = tail_c
  return found
endfunction
"}}}
function! s:act_show(hi_group) dict abort "{{{
  if !self.hi_status
    if s:is_valid_4pos(self.target)
      let order_list = s:highlight_order(self.target)
      for order in order_list
        let self.hi_idlist += s:matchaddpos(a:hi_group, order)
      endfor
      let self.hi_status = 1
    endif
    call filter(self.hi_idlist, 'v:val > 0')
  endif
endfunction
"}}}
function! s:act_quench() dict abort "{{{
  if self.hi_status
    call map(self.hi_idlist, 'matchdelete(v:val)')
    call filter(self.hi_idlist, 'v:val > 0')
    let self.hi_status = 0
  endif
endfunction
"}}}
function! s:act_add_pair(buns, undojoin, done, next_act) dict abort "{{{
  let target   = self.target
  let modmark  = self.modmark
  let opt      = self.opt
  let undojoin = a:undojoin
  let done     = a:done
  let indent   = [0, 0]
  let is_linewise = [0, 0]

  if s:is_valid_4pos(target) && s:is_equal_or_ahead(target.head2, target.head1)
    if target.head2[2] != col([target.head2[1], '$'])
      let target.head2[0:3] = s:get_right_pos(target.head2)
    endif

    let indentopt = s:set_indent(opt)
    try
      let pos = target.head1
      let [is_linewise[0], indent[0], head] = s:add_former(a:buns, pos, opt, undojoin)
      let pos = s:push1(copy(target.head2), target, a:buns, indent, is_linewise)
      let [is_linewise[1], indent[1], tail] = s:add_latter(a:buns, pos, opt)
    catch /^Vim\%((\a\+)\)\=:E21/
      throw 'OperatorSandwichError:Add:ReadOnly'
    finally
      call s:restore_indent(indentopt)
    endtry

    " update modmark
    if modmark.head == s:null_pos || s:is_ahead(modmark.head, head)
      let modmark.head = head
    endif
    if modmark.tail == s:null_pos
      let modmark.tail = tail
    else
      call s:shift_for_add(modmark.tail, target, a:buns, indent, is_linewise)
      if s:is_ahead(tail, modmark.tail)
        let modmark.tail = tail
      endif
    endif

    " update cursor positions
    call s:shift_for_add(self.cursor.inner_head, target, a:buns, indent, is_linewise)
    call s:shift_for_add(self.cursor.keep,       target, a:buns, indent, is_linewise)
    call s:shift_for_add(self.cursor.inner_tail, target, a:buns, indent, is_linewise)

    " update next_act
    let a:next_act.region.head = copy(head)
    let a:next_act.region.tail = s:get_left_pos(tail)

    let undojoin = 0
    let done     = 1
  endif

  return [undojoin, done]
endfunction
"}}}
function! s:act_delete_pair(done, next_act) dict abort  "{{{
  let target   = self.target
  let modmark  = self.modmark
  let opt      = self.opt
  let done     = a:done

  if s:is_valid_4pos(target) && s:is_ahead(target.head2, target.tail1)
    let reg = ['"', getreg('"'), getregtype('"')]
    let deletion = ['', '']
    let is_linewise = [0, 0]
    try
      let former_head = target.head1
      let former_tail = target.tail1
      let latter_head = target.head2
      let [deletion[0], is_linewise[0], head] = s:delete_former(former_head, former_tail, latter_head, opt)

      let latter_head = s:pull1(copy(target.head2), target, deletion, is_linewise)
      let latter_tail = s:pull1(copy(target.tail2), target, deletion, is_linewise)
      let [deletion[1], is_linewise[1], tail] = s:delete_latter(latter_head, latter_tail, former_head, opt)
    catch /^Vim\%((\a\+)\)\=:E21/
      throw 'OperatorSandwichError:Delete:ReadOnly'
    finally
      call call('setreg', reg)
    endtry

    " update modmark
    if modmark.head == s:null_pos || s:is_ahead(modmark.head, head)
      let modmark.head = head
    endif
    " NOTE: Probably, there is no possibility to delete breakings along multiple acts.
    if !done
      if modmark.tail == s:null_pos
        let modmark.tail = tail
      else
        call s:shift_for_delete(modmark.tail, target, deletion, is_linewise)
        if tail[1] >= modmark.tail[1]
          let modmark.tail = tail
        endif
      endif
    endif

    " update cursor positions
    call s:shift_for_delete(self.cursor.inner_head, target, deletion, is_linewise)
    call s:shift_for_delete(self.cursor.keep,       target, deletion, is_linewise)
    call s:shift_for_delete(self.cursor.inner_tail, target, deletion, is_linewise)

    " update next_act
    let a:next_act.region.head = copy(head)
    let a:next_act.region.tail = s:get_left_pos(tail)

    let done = 1
  endif
  return done
endfunction
"}}}
function! s:act_replace_pair(buns, undojoin, done, next_act) dict abort "{{{
  let target   = self.target
  let modmark  = self.modmark
  let opt      = self.opt
  let undojoin = a:undojoin
  let done     = a:done

  if s:is_valid_4pos(target) && s:is_ahead(target.head2, target.tail1)
    set virtualedit=
    let next_head = s:get_right_pos(target.tail1)
    let next_tail = s:get_left_pos(target.head2)
    set virtualedit=onemore

    let reg         = ['"', getreg('"'), getregtype('"')]
    let deletion    = ['', '']
    let indent      = [0, 0]
    let is_linewise = [0, 0]
    let indentopt   = s:set_indent(opt)
    try
      let within_a_line = target.tail1[1] == target.head2[1]
      let former_head = target.head1
      let former_tail = target.tail1
      let latter_head = copy(target.head2)
      let latter_tail = copy(target.tail2)
      let [deletion[0], is_linewise[0], indent[0], head] = s:replace_former(a:buns[0], former_head, former_tail, within_a_line, opt, undojoin)

      call s:pull1(latter_head, target, deletion, is_linewise)
      call s:push1(latter_head, target, a:buns, indent, is_linewise)
      call s:pull1(latter_tail, target, deletion, is_linewise)
      call s:push1(latter_tail, target, a:buns, indent, is_linewise)
      let [deletion[1], is_linewise[1], indent[1], tail] = s:replace_latter(a:buns[1], latter_head, latter_tail, within_a_line, opt)
    catch /^Vim\%((\a\+)\)\=:E21/
      throw 'OperatorSandwichError:Replace:ReadOnly'
    finally
      call call('setreg', reg)
      call s:restore_indent(indentopt)
    endtry

    " update modmark
    if modmark.head == s:null_pos || s:is_ahead(modmark.head, head)
      let modmark.head = copy(head)
    endif
    if !done
      if modmark.tail == s:null_pos
        let modmark.tail = copy(tail)
      else
        call s:shift_for_replace(modmark.tail, target, a:buns, deletion, indent, is_linewise)
        if modmark.tail[1] < tail[1]
          let modmark.tail = copy(tail)
        endif
      endif
    endif

    " update cursor positions
    call s:shift_for_replace(self.cursor.keep, target, a:buns, deletion, indent, is_linewise)
    call s:shift_for_replace(next_head, target, a:buns, deletion, indent, is_linewise)
    call s:shift_for_replace(next_tail, target, a:buns, deletion, indent, is_linewise)
    if self.cursor.inner_head == s:null_pos || target.head1[1] <= self.cursor.inner_head[1]
      let self.cursor.inner_head = copy(next_head)
    endif
    if self.cursor.inner_tail == s:null_pos
      let self.cursor.inner_tail = copy(next_tail)
    else
      call s:shift_for_replace(self.cursor.inner_tail, target, a:buns, deletion, indent, is_linewise)
      if self.cursor.inner_tail[1] <= next_tail[1]
        let self.cursor.inner_tail = copy(next_tail)
      endif
    endif

    " update next_act
    let a:next_act.region.head = next_head
    let a:next_act.region.tail = next_tail

    let undojoin = 0
    let done     = 1
  endif
  return [undojoin, done]
endfunction
"}}}
function! s:set_indent(opt) abort "{{{
  let indentopt = {
        \   'autoindent': {
        \     'restore': 0,
        \     'value'  : [&l:autoindent, &l:smartindent, &l:cindent, &l:indentexpr],
        \   },
        \   'indentkeys': {
        \     'restore': 0,
        \     'name'   : '',
        \     'value'  : '',
        \   },
        \ }

  " set autoindent options
  if a:opt.of('autoindent') == 0
    let [&l:autoindent, &l:smartindent, &l:cindent, &l:indentexpr] = [0, 0, 0, '']
    let indentopt.autoindent.restore = 1
  elseif a:opt.of('autoindent') == 1
    let [&l:autoindent, &l:smartindent, &l:cindent, &l:indentexpr] = [1, 0, 0, '']
    let indentopt.autoindent.restore = 1
  elseif a:opt.of('autoindent') == 2
    " NOTE: 'Smartindent' requires 'autoindent'. :help 'smartindent'
    let [&l:autoindent, &l:smartindent, &l:cindent, &l:indentexpr] = [1, 1, 0, '']
    let indentopt.autoindent.restore = 1
  elseif a:opt.of('autoindent') == 3
    let [&l:cindent, &l:indentexpr] = [1, '']
    let indentopt.autoindent.restore = 1
  endif

  " set indentkeys
  if &l:indentexpr !=# ''
    let indentopt.indentkeys.name  = 'indentkeys'
    let indentopt.indentkeys.value = &l:indentkeys
  else
    let indentopt.indentkeys.name  = 'cinkeys'
    let indentopt.indentkeys.value = &l:cinkeys
  endif
  for [sign, val] in [['', a:opt.of('indentkeys')], ['+', a:opt.of('indentkeys+')]]
    if val !=# ''
      execute printf('setlocal %s%s=%s', indentopt.indentkeys.name, sign, val)
      let indentopt.indentkeys.restore = 1
    endif
  endfor
  if a:opt.of('indentkeys-') !=# ''
    " It looks there is no way to add ',' itself to 'indentkeys'
    for item in split(a:opt.of('indentkeys-'), ',')
      execute printf('setlocal %s-=%s', indentopt.indentkeys.name, item)
    endfor
    let indentopt.indentkeys.restore = 1
  endif
  return indentopt
endfunction
"}}}
function! s:restore_indent(indentopt) abort  "{{{
  " restore indentkeys first
  if a:indentopt.indentkeys.restore
    execute printf('setlocal %s=%s', a:indentopt.indentkeys.name, a:indentopt.indentkeys.value)
  endif

  " restore autoindent options
  if a:indentopt.autoindent.restore
    let [&l:autoindent, &l:smartindent, &l:cindent, &l:indentexpr] = a:indentopt.autoindent.value
  endif
endfunction
"}}}
function! s:add_former(buns, pos, opt, ...) abort  "{{{
  let undojoin_cmd = get(a:000, 0, 0) ? 'undojoin | ' : ''
  let opt_linewise  = a:opt.of('linewise')
  if opt_linewise
    let startinsert = a:opt.of('noremap') ? 'normal! O' : "normal \<Plug>(sandwich-O)"
  else
    let startinsert = a:opt.of('noremap') ? 'normal! i' : "normal \<Plug>(sandwich-i)"
  endif
  call s:add_portion(a:buns[0], a:pos, undojoin_cmd, startinsert)
  return [opt_linewise, indent(line("']")), getpos("'[")]
endfunction
"}}}
function! s:add_latter(buns, pos, opt) abort  "{{{
  let undojoin_cmd = ''
  let opt_linewise = a:opt.of('linewise')
  if opt_linewise
    let startinsert = a:opt.of('noremap') ? 'normal! o' : "normal \<Plug>(sandwich-o)"
  else
    let startinsert = a:opt.of('noremap') ? 'normal! i' : "normal \<Plug>(sandwich-i)"
  endif
  call s:add_portion(a:buns[1], a:pos, undojoin_cmd, startinsert)
  return [opt_linewise, indent(line("']")), getpos("']")]
endfunction
"}}}
function! s:add_portion(bun, pos, undojoin_cmd, startinsert) abort "{{{
  call setpos('.', a:pos)
  if s:is_in_cmdline_window
    " workaround for a bug in cmdline-window
    call s:paste(a:bun, a:undojoin_cmd)
  else
    execute a:undojoin_cmd . 'silent ' . a:startinsert . a:bun
  endif
endfunction
"}}}
function! s:delete_former(head, tail, latter_head, opt, ...) abort  "{{{
  let is_linewise  = 0
  let opt_linewise = a:opt.of('linewise')
  let undojoin_cmd = get(a:000, 0, 0) ? 'undojoin | ' : ''
  let deletion = s:delete_portion(a:head, a:tail, undojoin_cmd)
  if opt_linewise == 2 || (opt_linewise == 1 && match(getline('.'), '^\s*$') > -1)
    if line('.') != a:latter_head[1]
      .delete
      let is_linewise = 1
    endif
    let head = getpos("']")
  else
    let head = getpos('.')
  endif
  return [deletion, is_linewise, head]
endfunction
"}}}
function! s:delete_latter(head, tail, former_head, opt) abort  "{{{
  let is_linewise  = 0
  let opt_linewise = a:opt.of('linewise')
  let undojoin_cmd = ''
  let deletion = s:delete_portion(a:head, a:tail, undojoin_cmd)
  if opt_linewise == 2 || (opt_linewise == 1 && match(getline('.'), '^\s*$') > -1)
    .delete
    let is_linewise = 1
    let tail = getpos("']")
    if tail[1] != 1 && tail[1] != a:former_head[1]
      let prevline = line("']") - 1
      let tail = [0, prevline, col([prevline, '$']), 0]
    endif
  else
    let tail = getpos("']")
  endif
  return [deletion, is_linewise, tail]
endfunction
"}}}
function! s:delete_portion(head, tail, undojoin_cmd) abort  "{{{
  let cmd = "%ssilent normal! \"\"dv:call setpos('\.', %s)\<CR>"
  call setpos('.', a:head)
  let @@ = ''
  execute printf(cmd, a:undojoin_cmd, 'a:tail')
  return @@
endfunction
"}}}
function! s:replace_former(bun, head, tail, within_a_line, opt, ...) abort "{{{
  let is_linewise  = 0
  let opt_linewise = a:opt.of('linewise')
  let undojoin_cmd = get(a:000, 0, 0) ? 'undojoin | ' : ''
  let deletion = s:delete_portion(a:head, a:tail, undojoin_cmd)

  if s:is_in_cmdline_window
    " workaround for a bug in cmdline-window
    call s:paste(a:bun)
  else
    if opt_linewise == 1 && getline('.') =~# '^\s*$'
      .delete
      let startinsert = a:opt.of('noremap', 'recipe_add') ? 'normal! O' : "normal \<Plug>(sandwich-O)"
      execute 'silent ' . startinsert . a:bun
      let is_linewise = 1
    elseif opt_linewise == 2
      if !a:within_a_line
        .delete
      endif
      let startinsert = a:opt.of('noremap', 'recipe_add') ? 'normal! O' : "normal \<Plug>(sandwich-O)"
      execute 'silent ' . startinsert . a:bun
      let is_linewise = 1
    else
      let startinsert = a:opt.of('noremap', 'recipe_add') ? 'normal! i' : "normal \<Plug>(sandwich-i)"
      execute 'silent ' . startinsert . a:bun
    endif
  endif
  return [deletion, is_linewise, indent(line("']")), getpos("'[")]
endfunction
"}}}
function! s:replace_latter(bun, head, tail, within_a_line, opt) abort "{{{
  let is_linewise  = 0
  let opt_linewise = a:opt.of('linewise')
  let undojoin_cmd = ''
  let deletion = s:delete_portion(a:head, a:tail, undojoin_cmd)

  if s:is_in_cmdline_window
    " workaround for a bug in cmdline-window
    call s:paste(a:bun)
    let tail = getpos("']")
  else
    if opt_linewise == 1 && getline('.') =~# '^\s*$'
      let startinsert = a:opt.of('noremap', 'recipe_add') ? 'normal! o' : "normal \<Plug>(sandwich-o)"
      let current = line('.')
      let fileend = line('$')
      .delete
      if current != fileend
        normal! k
      endif
      execute 'silent ' . startinsert . a:bun
      let tail = getpos("']")
      let is_linewise = 1
    elseif opt_linewise == 2
      let startinsert = a:opt.of('noremap', 'recipe_add') ? 'normal! o' : "normal \<Plug>(sandwich-o)"
      if a:within_a_line
        " exceptional behavior
        let lnum = line('.')
        execute 'silent ' . startinsert . a:bun
        let tail = getpos("']")
        execute lnum . 'delete'
        let tail = [0, tail[1]-1, tail[2], 0]
      else
        " usual way (same as opt_linewise == 1)
        let current = line('.')
        let fileend = line('$')
        .delete
        if current != fileend
          normal! k
        endif
        execute 'silent ' . startinsert . a:bun
        let tail = getpos("']")
      endif
      let is_linewise = 1
    else
      let startinsert = a:opt.of('noremap', 'recipe_add') ? 'normal! i' : "normal \<Plug>(sandwich-i)"
      execute 'silent ' . startinsert . a:bun
      let tail = getpos("']")
    endif
  endif
  return [deletion, is_linewise, indent(line("']")), tail]
endfunction
"}}}
function! s:paste(bun, ...) abort "{{{
  let undojoin_cmd = a:0 > 0 ? a:1 : ''
  let reg = ['"', getreg('"'), getregtype('"')]
  let @@ = a:bun
  if s:has_gui_running
    execute undojoin_cmd . 'normal! ""P'
  else
    let paste  = &paste
    let &paste = 1
    execute undojoin_cmd . 'normal! ""P'
    let &paste = paste
  endif
  call call('setreg', reg)
endfunction
"}}}
function! s:highlight_order(target) abort "{{{
  let n = 0
  let order = []
  let order_list = []
  for [head, tail] in [[a:target.head1, a:target.tail1], [a:target.head2, a:target.tail2]]
    if head != s:null_pos && tail != s:null_pos && s:is_equal_or_ahead(tail, head)
      if head[1] == tail[1]
        let order += [head[1:2] + [tail[2] - head[2] + 1]]
        let n += 1
      else
        let order += [head[1:2] + [col([head[1], '$']) - head[2] + 1]]
        let order += [[tail[1], 1] + [tail[2]]]
        let n += 2
        for lnum in range(head[1]+1, tail[1]-1)
          let order += [[lnum]]

          if n == 7
            let order_list += [order]
            let order = []
            let n = 0
          else
            let n += 1
          endif
        endfor
      endif
    endif
  endfor
  if order != []
    call add(order_list, order)
  endif
  return order_list
endfunction
"}}}
" function! s:matchaddpos(group, pos) abort "{{{
if s:has_patch_7_4_362
  function! s:matchaddpos(group, pos) abort
    return [matchaddpos(a:group, a:pos)]
  endfunction
else
  function! s:matchaddpos(group, pos) abort
    let id_list = []
    for pos in a:pos
      if len(pos) == 1
        let id_list += [matchadd(a:group, printf('\%%%dl', pos[0]))]
      else
        let id_list += [matchadd(a:group, printf('\%%%dl\%%>%dc.*\%%<%dc', pos[0], pos[1]-1, pos[1]+pos[2]))]
      endif
    endfor
    return id_list
  endfunction
endif
"}}}
let s:act = {
      \   'region' : copy(s:null_2pos),
      \   'target' : copy(s:null_4pos),
      \   'cursor' : {},
      \   'modmark': {},
      \   'opt'    : {},
      \   'hi_status': 0,
      \   'hi_idlist': [],
      \   'initialize'    : function('s:act_initialize'),
      \   'add_pair'      : function('s:act_add_pair'),
      \   'delete_pair'   : function('s:act_delete_pair'),
      \   'replace_pair'  : function('s:act_replace_pair'),
      \   'match'         : function('s:act_match'),
      \   '_match_recipes': function('s:act__match_recipes'),
      \   '_match_edges'  : function('s:act__match_edges'),
      \   'set_target'    : function('s:act_set_target'),
      \   'skip_space'    : function('s:act_skip_space'),
      \   'show'          : function('s:act_show'),
      \   'quench'        : function('s:act_quench'),
      \ }
"}}}
" stuff object - controlling a count of editing {{{
" NOTE: A stuff object has line number of act objects in stuff.acts.
"       If operator.motionwise is 'char' or 'line', a stuff object has an act object.
"       If operator.motionwise is 'block', a stuff object has the same number of
"       act objects with the lines in target region.
function! s:stuff_initialize(cursor, modmark, opt) dict abort  "{{{
  let self.cursor  = a:cursor
  let self.modmark = a:modmark
  let self.opt     = copy(a:opt)
  for act in self.acts
    call act.initialize(self.cursor, self.modmark, self.opt)
  endfor
endfunction
"}}}
function! s:stuff_fill() dict abort  "{{{
  let lack = self.n - len(self.acts)
  if lack > 0
    let fillings = map(range(lack), 'deepcopy(s:act)')
    for act in fillings
      call act.initialize(self.cursor, self.modmark, self.opt)
    endfor
    let self.acts += fillings
  endif
endfunction
"}}}
function! s:stuff_set_region(region_list) dict abort "{{{
  for i in range(len(a:region_list))
    let act = self.acts[i]
    let act.region = a:region_list[i]
  endfor
endfunction
"}}}
function! s:stuff_set_target() dict abort  "{{{
  for i in range(self.n)
    let act = self.acts[i]
    call act.set_target()
  endfor
endfunction
"}}}
function! s:stuff_match(recipes) dict abort  "{{{
  let recipes = deepcopy(a:recipes)
  let filter  = 's:has_action(v:val, "delete")'
  call filter(recipes, filter)

  " uniq recipes
  let opt = self.opt
  let opt_regex   = opt.of('regex')
  let opt_expr    = opt.has('expr') && opt.of('expr', 'recipe_delete')
  let opt_noremap = opt.of('noremap', 'recipe_delete')
  call s:uniq_recipes(recipes, opt_regex, opt_expr, opt_noremap)

  for i in range(self.n)
    let act = self.acts[i]
    call act.match(recipes)
  endfor
endfunction
"}}}
function! s:stuff_query(recipes) dict abort  "{{{
  let filter = 'has_key(v:val, "buns")
          \ && (!has_key(v:val, "regex") || !v:val.regex)
          \ && s:has_action(v:val, "add")'
  let recipes = filter(deepcopy(a:recipes), filter)
  let opt = self.opt
  let clock = deepcopy(s:clock)
  let timeoutlen = max([0, s:get('timeoutlen', &timeoutlen)])

  " query phase
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
    let n_fwd = len(filter(recipes, 's:is_input_matched(v:val, input, self.opt, 0)'))

    " check complete match
    let n_comp = len(filter(copy(recipes), 's:is_input_matched(v:val, input, self.opt, 1)'))
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
        break
      endif
    endif

    if recipes == [] | break | endif
  endwhile
  call clock.stop()

  " pick up and register a recipe
  if filter(recipes, 's:is_input_matched(v:val, input, self.opt, 1)') != []
    let recipe = recipes[0]
  else
    if input ==# "\<Esc>" || input ==# "\<C-c>" || input ==# ''
      let recipe = {}
    else
      let c = split(input, '\zs')[0]
      let recipe = {'buns': [c, c], 'expr': 0}
    endif
  endif

  if has_key(recipe, 'buns')
    call extend(self.buns, remove(recipe, 'buns'))
    call self.opt.update('recipe_add', recipe)
  endif
  call clock.stop()
endfunction
"}}}
function! s:stuff_mimic(original) dict abort "{{{
  let self.buns = a:original.buns
  call self.opt.update('recipe_add', a:original.opt.recipe_add)
endfunction
"}}}
function! s:stuff_show(hi_group) dict abort "{{{
  if self.opt.of('highlight')
    for i in range(self.n)
      let act = self.acts[i]
      call act.show(a:hi_group)
    endfor
    redraw
  endif
endfunction
"}}}
function! s:stuff_quench() dict abort "{{{
  if self.opt.of('highlight')
    for i in range(self.n)
      let act = self.acts[i]
      call act.quench()
    endfor
  endif
endfunction
"}}}
function! s:stuff_blink(hi_group, duration, ...) dict abort "{{{
  if self.opt.of('highlight')
    let clock = deepcopy(s:clock)
    let hi_exited = 0
    let feedkey = get(a:000, 0, 0)

    call self.show(a:hi_group)
    try
      let c = 0
      call clock.start()
      while empty(c)
        let c = getchar(0)
        if clock.started && clock.elapsed() > a:duration
          break
        endif
        sleep 20m
      endwhile

      if c != 0
        let c = type(c) == s:type_num ? nr2char(c) : c
        let hi_exited = 1
        if feedkey
          call feedkeys(c, 't')
        endif
      endif
    finally
      call self.quench()
      call clock.stop()
      return hi_exited
    endtry
  endif
endfunction
"}}}
function! s:stuff_skip_space(n) dict abort  "{{{
  " skip space only in the first count.
  if a:n == 0
    for i in range(self.n)
      let act = self.acts[i]
      call act.skip_space()
      call act.set_target()
    endfor

    " for cursor positions
    if !self.opt.of('linewise')
      let top_act = self.acts[self.n-1]
      let bot_act = self.acts[0]
      let self.cursor.inner_head = deepcopy(top_act.region.head)
      let self.cursor.inner_tail = deepcopy(bot_act.region.tail)
    endif
  endif
endfunction
"}}}
function! s:stuff_command() dict abort  "{{{
  let modmark = self.modmark
  let head = getpos("'[")
  let tail = getpos("']")
  call setpos("'[", modmark.head)
  call setpos("']", modmark.tail)
  for cmd in self.opt.of('command')
    execute cmd
  endfor

  let mod_head = getpos("'[")
  let mod_tail = getpos("']")
  if head != mod_head || tail != mod_tail
    let self.modmark.head[0:3] = mod_head
    let self.modmark.tail[0:3] = mod_tail
  endif
endfunction
"}}}
function! s:stuff_get_buns() dict abort  "{{{
  let buns = self.buns
  let opt_expr = self.opt.of('expr')
  if (opt_expr && !self.evaluated) || opt_expr == 2
    let buns = opt_expr == 2 ? deepcopy(buns) : buns
    let buns[0] = s:eval(buns[0], 1)
    let buns[1] = s:eval(buns[1], 0)
    let self.evaluated = 1
  endif
  return buns
endfunction
"}}}
function! s:stuff_add_once(next_stuff, undojoin) dict abort  "{{{
  let buns = self.get_buns()
  let undojoin = a:undojoin
  if buns[0] !=# '' || buns[1] !=# ''
    for i in range(self.n)
      let act      = self.acts[i]
      let next_act = a:next_stuff.acts[i]
      let [undojoin, self.done] = act.add_pair(buns, undojoin, self.done, next_act)
    endfor
  endif
endfunction
"}}}
function! s:stuff_delete_once(next_stuff) dict abort  "{{{
  for i in range(self.n)
    let act = self.acts[i]
    let next_act = a:next_stuff.acts[i]
    let self.done = act.delete_pair(self.done, next_act)
  endfor
endfunction
"}}}
function! s:stuff_replace_once(next_stuff, undojoin) dict abort  "{{{
  let buns = self.get_buns()
  let undojoin = a:undojoin
  for i in range(self.n)
    let act      = self.acts[i]
    let next_act = a:next_stuff.acts[i]
    let [undojoin, self.done] = act.replace_pair(buns, undojoin, self.done, next_act)
  endfor
endfunction
"}}}
function! s:is_input_matched(candidate, input, opt, flag) abort "{{{
  if !has_key(a:candidate, 'buns')
    return 0
  elseif !a:flag && a:input ==# ''
    return 1
  endif

  let candidate = deepcopy(a:candidate)
  call a:opt.update('recipe_add', candidate)

  " 'input' is necessary for 'expr' buns
  if a:opt.of('expr') && !has_key(candidate, 'input')
    return 0
  endif

  " If a:flag == 0, check forward match. Otherwise, check complete match.
  let inputs = get(candidate, 'input', candidate['buns'])
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
let s:stuff = {
      \   'buns'   : [],
      \   'done'   : 0,
      \   'cursor' : {},
      \   'modmark': {},
      \   'opt'    : {},
      \   'n'      : 0,
      \   'acts'   : [],
      \   'evaluated': 0,
      \   'initialize'  : function('s:stuff_initialize'),
      \   'fill'        : function('s:stuff_fill'),
      \   'set_region'  : function('s:stuff_set_region'),
      \   'set_target'  : function('s:stuff_set_target'),
      \   'match'       : function('s:stuff_match'),
      \   'query'       : function('s:stuff_query'),
      \   'mimic'       : function('s:stuff_mimic'),
      \   'show'        : function('s:stuff_show'),
      \   'quench'      : function('s:stuff_quench'),
      \   'blink'       : function('s:stuff_blink'),
      \   'skip_space'  : function('s:stuff_skip_space'),
      \   'command'     : function('s:stuff_command'),
      \   'get_buns'    : function('s:stuff_get_buns'),
      \   'add_once'    : function('s:stuff_add_once'),
      \   'delete_once' : function('s:stuff_delete_once'),
      \   'replace_once': function('s:stuff_replace_once'),
      \ }
"}}}
" operator object - controlling a whole operation {{{
" NOTE: A operator object has [count] of stuff objects in operator.basket.
function! s:operator_execute(kind, motionwise) dict abort  "{{{
  " FIXME: What is the best practice to handle exceptions?
  "        Serious lack of the experience with error handlings...
  let errormsg = ''
  let options = s:shift_options(a:kind, self.mode)
  try
    call self.recipes.integrate(a:kind, a:motionwise, self.mode)
    call self.initialize(a:kind, a:motionwise)
    if self.state >= 0
      call self[a:kind]()
    endif
  catch /^OperatorSandwichError:\%(Add\|Delete\|Replace\):ReadOnly/
    let errormsg = 'operator-sandwich: Cannot make changes to read-only buffer.'
  catch /^OperatorSandwichCancel/
    " I don't know why it can be released here, but anyway it can be done.
    unlet! g:operator#sandwich#object
  catch
    let errormsg = printf('operator-sandwich: Unanticipated error. [%s] %s', v:throwpoint, v:exception)
    unlet! g:operator#sandwich#object
  finally
    if errormsg !=# ''
      echohl ErrorMsg
      echomsg errormsg
      echohl NONE
    endif

    call self.finalize(a:kind)
    call s:restore_options(a:kind, self.mode, options)
  endtry
endfunction
"}}}
function! s:operator_initialize(kind, motionwise) dict abort "{{{
  let region = s:get_assigned_region(a:kind, a:motionwise)
  let region_list = a:motionwise ==# 'block' ? self.split(region) : [region]

  if region == s:null_2pos
    " deactivate
    let self.state = -1
  endif

  let n = len(region_list)  " Number of lines in the target region
  let self.cursor.inner_head = deepcopy(region.head)
  let self.cursor.inner_tail = deepcopy(region.tail)
  call self.opt.update('default', g:operator#sandwich#options[a:kind][a:motionwise])

  if self.state
    " build stuff
    let stuff = deepcopy(s:stuff)
    let stuff.acts = map(range(n), 'deepcopy(s:act)')

    " put stuffs as needed
    let self.basket = map(range(self.count), 'deepcopy(stuff)')

    " connect links
    for stuff in self.basket
      let stuff.n = n
      call stuff.initialize(self.cursor, self.modmark, self.opt)
    endfor
  else
    let self.view = winsaveview()
    let self.modmark.head = copy(s:null_pos)
    let self.modmark.tail = copy(s:null_pos)

    for stuff in self.basket
      let stuff.n = n
      let stuff.done = 0
      call stuff.fill()
    endfor
  endif

  " set initial values
  let stuff = self.basket[0]
  call stuff.set_region(region_list)
endfunction
"}}}
function! s:operator_split(region) dict abort  "{{{
  let reg  = ['"', getreg('"'), getregtype('"')]
  let view = winsaveview()
  let virtualedit = &virtualedit
  let &virtualedit = 'all'
  try
    if self.blockwidth == 0
      " The case for blockwise motions in operator-pending mode
      execute "normal! `[\<C-v>`]"
      silent normal! ""y
      let regtype = getregtype('"')
      let self.blockwidth = str2nr(regtype[1:])
    endif
    let disp_region = map(copy(a:region), 's:get_displaycoord(v:val)')
    let lnum_top    = disp_region.head[0]
    let lnum_bottom = disp_region.tail[0]
    let col_head    = disp_region.head[1]
    let col_tail    = col_head + self.blockwidth - 1
    let region_list = []
    if self.extended
      for lnum in reverse(range(lnum_top, lnum_bottom))
        call s:set_displaycoord([lnum, col_head])
        let head = getpos('.')
        let tail = [0, lnum, col([lnum, '$']) - 1, 0]
        if head[3] == 0 && s:is_equal_or_ahead(tail, head)
          let region_list += [{'head': head, 'tail': tail}]
        endif
      endfor
    else
      for lnum in reverse(range(lnum_top, lnum_bottom))
        call s:set_displaycoord([lnum, col_head])
        let head = getpos('.')
        call s:set_displaycoord([lnum, col_tail])
        let tail = getpos('.')
        let endcol = col([lnum, '$'])
        if head[2] != endcol && s:is_equal_or_ahead(tail, head)
          if tail[2] == endcol
            let tail[2] = endcol - 1
            let tail[3] = 0
          endif
          let region_list += [{'head': head, 'tail': tail}]
        endif
      endfor
    endif
  finally
    call call('setreg', reg)
    call winrestview(view)
    let &virtualedit = virtualedit
  endtry
  return region_list
endfunction
"}}}
function! s:operator_add() dict abort "{{{
  let undojoin = 0
  for i in range(self.count)
    let stuff = self.basket[i]
    let next_stuff = get(self.basket, i + 1, deepcopy(stuff))
    let opt = stuff.opt

    call stuff.set_target()
    if self.state
      " query preferable buns
      call winrestview(self.view)
      call stuff.show('OperatorSandwichBuns')
      try
        call stuff.query(self.recipes.integrated)
      finally
        call stuff.quench()
      endtry
    endif
    if stuff.buns == [] || len(stuff.buns) < 2
      break
    endif
    call stuff.skip_space(i)

    if opt.of('query_once') && self.count > 1 && i == 0 && self.state
      for j in range(1, len(self.basket) - 1)
        call self.basket[j].mimic(stuff)
      endfor
      let self.state = 0
    endif

    call stuff.add_once(next_stuff, undojoin)
    let self.cursor.head = copy(self.modmark.head)
    let self.cursor.tail = s:get_left_pos(self.modmark.tail)
    let undojoin = self.state ? 1 : 0

    if stuff.done && opt.of('command') != []
      call stuff.command()
    endif
  endfor
endfunction
"}}}
function! s:operator_delete() dict abort  "{{{
  let hi_exited = 0
  let hi_duration = s:get('highlight_duration', 200)

  for i in range(self.count)
    let stuff = self.basket[i]
    let next_stuff = get(self.basket, i + 1, deepcopy(stuff))
    let opt = stuff.opt

    call stuff.match(self.recipes.integrated)
    if filter(copy(stuff.acts), 's:is_valid_4pos(v:val.target)') == []
      break
    endif

    if !hi_exited && opt.of('highlight') && hi_duration > 0
      call winrestview(self.view)
      let hi_exited = stuff.blink('OperatorSandwichBuns', hi_duration, 1)
    endif

    call stuff.delete_once(next_stuff)
    let self.cursor.head = copy(self.modmark.head)
    let self.cursor.tail = s:get_left_pos(self.modmark.tail)

    if stuff.done && opt.of('command') != []
      call stuff.command()
    endif
  endfor
endfunction
"}}}
function! s:operator_replace() dict abort  "{{{
  let self.cursor.inner_head = copy(s:null_pos)
  let self.cursor.inner_tail = copy(s:null_pos)

  let undojoin = 0
  for i in range(self.count)
    let stuff = self.basket[i]
    let next_stuff = get(self.basket, i + 1, deepcopy(stuff))
    let opt = stuff.opt

    call stuff.match(self.recipes.integrated)
    if filter(copy(stuff.acts), 's:is_valid_4pos(v:val.target)') == []
      break
    endif

    if self.state
      " query preferable buns
      call winrestview(self.view)
      call stuff.show('OperatorSandwichBuns')
      try
        call stuff.query(self.recipes.integrated)
      finally
        call stuff.quench()
      endtry
    endif
    if stuff.buns == [] || len(stuff.buns) < 2
      break
    endif

    if opt.of('query_once') && self.count > 1 && i == 0 && self.state
      for j in range(1, len(self.basket) - 1)
        call self.basket[j].mimic(stuff)
      endfor
      let self.state = 0
    endif

    call stuff.replace_once(next_stuff, undojoin)
    let self.cursor.head = copy(self.modmark.head)
    let self.cursor.tail = s:get_left_pos(self.modmark.tail)
    let undojoin = self.state ? 1 : 0

    if stuff.done && opt.of('command') != []
      call stuff.command()
    endif
  endfor
endfunction
"}}}
function! s:operator_finalize(kind) dict abort  "{{{
  if self.state >= 0
    " restore view
    if self.view != {}
      call winrestview(self.view)
      let self.view = {}
    endif

    if self.basket != [] && filter(copy(self.basket), 'v:val.done') != []
      " set modified marks
      let modmark = self.modmark
      if modmark.head != s:null_pos && modmark.tail != s:null_pos
            \ && s:is_equal_or_ahead(modmark.tail, modmark.head)
        call setpos("'[", modmark.head)
        call setpos("']", modmark.tail)
      endif

      " set cursor position
      let cursor_opt = 'inner_head'
      for i in range(self.count - 1, 0, -1)
        let stuff = self.basket[i]
        if stuff.done
          let cursor_opt = stuff.opt.of('cursor')
          let cursor_opt = cursor_opt =~# '^\%(keep\|\%(inner_\)\?\%(head\|tail\)\)$'
                        \ ? cursor_opt : 'inner_head'
          break
        endif
      endfor

      if self.state || self.keepable
        let cursor = cursor_opt =~# '^\%(keep\|\%(inner_\)\?\%(head\|tail\)\)$' && self.cursor[cursor_opt] != s:null_pos
                   \ ? self.cursor[cursor_opt] : self.cursor['inner_head']
        let self.keepable = 0
      else
        " In the case of dot repeat, it is impossible to keep original position
        " unless self.keepable == 1.
        let cursor = cursor_opt =~# '^\%(inner_\)\?\%(head\|tail\)$' && self.cursor[cursor_opt] != s:null_pos
                   \ ? self.cursor[cursor_opt] : self.cursor['inner_head']
      endif

      if s:has_patch_7_4_310
        " set curswant explicitly
        call setpos('.', cursor + [cursor[2]])
      else
        call setpos('.', cursor)
      endif
    endif
  endif

  " set state
  let self.state = 0
endfunction
"}}}
function! s:operator_recipe_integrate(kind, motionwise, mode) dict abort  "{{{
  let self.integrated = []
  if self.arg_given
    let self.integrated += self.arg
  else
    let self.integrated += sandwich#get_recipes()
    let self.integrated += operator#sandwich#get_recipes()
  endif
  let self.integrated += self.synchro
  let filter = 's:has_filetype(v:val)
           \ && s:has_kind(v:val, a:kind)
           \ && s:has_motionwise(v:val, a:motionwise)
           \ && s:has_mode(v:val, a:mode)
           \ && s:expr_filter(v:val)'
  call filter(self.integrated, filter)
  call reverse(self.integrated)
endfunction
"}}}
function! s:shift_options(kind, mode) abort "{{{
  """ save options
  let options = {}
  let options.virtualedit = &virtualedit
  let options.whichwrap   = &whichwrap

  """ tweak appearance
  " hide_cursor
  if s:has_gui_running
    let options.cursor = &guicursor
    set guicursor+=n-o:block-NONE
  else
    let options.cursor = &t_ve
    set t_ve=
  endif

  " hide cursorline highlight if in visualmode.
  " FIXME: The cursorline would be shown at the top line of assigned region
  "        in a moment currently. This is not good. This could be avoidable
  "        if the tweak was done in operator#sandwich#prerequisite().
  "        However, since operatorfunc is possible not to be called (when
  "        motion or textobj is canceled), it cannot be restored safely...
  "        Another way to avoid is to set lazyredraw on constantly.
  if (a:kind ==# 'add' || a:kind ==# 'replace') && a:mode ==# 'x'
    let options.cursorline = &l:cursorline
    setlocal nocursorline
  endif

  """ shift options
  set virtualedit=onemore
  set whichwrap=h,l
  return options
endfunction
"}}}
function! s:restore_options(kind, mode, options) abort "{{{
  if (a:kind ==# 'add' || a:kind ==# 'replace') && a:mode ==# 'x'
    let &l:cursorline = a:options.cursorline
  endif

  if s:has_gui_running
    set guicursor&
    let &guicursor = a:options.cursor
  else
    let &t_ve = a:options.cursor
  endif

  let &virtualedit = a:options.virtualedit
  let &whichwrap   = a:options.whichwrap
endfunction
"}}}
let s:operator = {
      \   'state'     : 0,
      \   'count'     : 1,
      \   'mode'      : 'n',
      \   'view'      : {},
      \   'blockwidth': 0,
      \   'extended'  : 0,
      \   'keepable'  : 0,
      \   'recipes'   : {
      \     'arg'       : [],
      \     'synchro'   : [],
      \     'integrated': [],
      \     'integrate' : function('s:operator_recipe_integrate'),
      \   },
      \   'cursor': {
      \     'head'      : copy(s:null_pos),
      \     'inner_head': copy(s:null_pos),
      \     'keep'      : copy(s:null_pos),
      \     'inner_tail': copy(s:null_pos),
      \     'tail'      : copy(s:null_pos),
      \   },
      \   'modmark'   : copy(s:null_2pos),
      \   'opt'       : deepcopy(s:opt),
      \   'basket'    : [],
      \   'execute'   : function('s:operator_execute'),
      \   'initialize': function('s:operator_initialize'),
      \   'split'     : function('s:operator_split'),
      \   'add'       : function('s:operator_add'),
      \   'delete'    : function('s:operator_delete'),
      \   'replace'   : function('s:operator_replace'),
      \   'finalize'  : function('s:operator_finalize'),
      \ }
"}}}



""" Private funcs
" filters
function! s:has_filetype(candidate) abort "{{{
  if !has_key(a:candidate, 'filetype')
    return 1
  else
    let filetypes = split(&filetype, '\.')
    if filetypes == []
      let filter = 'v:val ==# "all" || v:val ==# ""'
    else
      let filter = 'v:val ==# "all" || (v:val !=# "" && match(filetypes, v:val) > -1)'
    endif
    return filter(copy(a:candidate['filetype']), filter) != []
  endif
endfunction
"}}}
function! s:has_kind(candidate, kind) abort "{{{
  if !has_key(a:candidate, 'kind')
    return 1
  else
    let filter = 'v:val ==# a:kind || v:val ==# "operator" || v:val ==# "all"'
    return filter(copy(a:candidate['kind']), filter) != []
  endif
endfunction
"}}}
function! s:has_motionwise(candidate, motionwise) abort "{{{
  if !has_key(a:candidate, 'motionwise')
    return 1
  else
    let filter = 'v:val ==# a:motionwise || v:val ==# "all"'
    return filter(copy(a:candidate['motionwise']), filter) != []
  endif
endfunction
"}}}
function! s:has_mode(candidate, mode) abort "{{{
  if !has_key(a:candidate, 'mode')
    return 1
  else
    return stridx(join(a:candidate['mode'], ''), a:mode) > -1
  endif
endfunction
"}}}
function! s:has_action(candidate, action) abort "{{{
  if !has_key(a:candidate, 'action')
    return 1
  else
    let filter = 'v:val ==# a:action || v:val ==# "all"'
    return filter(copy(a:candidate['action']), filter) != []
  endif
endfunction
"}}}
function! s:expr_filter(candidate) abort  "{{{
  if !has_key(a:candidate, 'expr_filter')
    return 1
  else
    for filter in a:candidate['expr_filter']
      if !eval(filter)
        return 0
      endif
    endfor
    return 1
  endif
endfunction
"}}}

" execute autocmd safely
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

" get and modify region
function! s:get_assigned_region(kind, motionwise) abort "{{{
  let region = {'head': getpos("'["), 'tail': getpos("']")}

  " early-quit conditions
  if !s:is_valid_region(a:kind, region, a:motionwise)
    return deepcopy(s:null_2pos)
  endif

  if a:motionwise ==# 'line'
    let region.head[2] = 1
    let region.tail[2] = col([region.tail[1], '$']) - 1
  else
    if region.tail[2] >= col([region.tail[1], '$'])
      let region.tail[2] -= 1
    endif
  endif
  if region.tail[2] < 1
    let region.tail[2] = 1
  endif

  " for multibyte characters
  if region.tail[2] != col([region.tail[1], '$']) && region.tail[3] == 0
    let cursor = getpos('.')
    call setpos('.', region.tail)
    call search('.', 'bc')
    let region.tail = getpos('.')
    call setpos('.', cursor)
  endif

  " check validity again
  if !s:is_valid_region(a:kind, region)
    return deepcopy(s:null_2pos)
  endif

  return region
endfunction
"}}}
function! s:is_valid_region(kind, region, ...) abort "{{{
  " If the third argument is given and it is 'line', ignore the geometric
  " condition of head and tail.
  return s:is_valid_2pos(a:region)
    \ && (
    \       (a:kind ==# 'add' && s:is_equal_or_ahead(a:region.tail, a:region.head))
    \    || ((a:kind ==# 'delete' || a:kind ==# 'replace') && s:is_ahead(a:region.tail, a:region.head))
    \    || (a:0 > 0 && a:1 ==# 'line')
    \    )
endfunction
"}}}
function! s:get_wider_region(head_edge, tail_edge) abort "{{{
  return [s:get_left_pos(a:head_edge), s:get_right_pos(a:tail_edge)]
endfunction
"}}}
function! s:get_left_pos(pos) abort  "{{{
  call setpos('.', a:pos)
  normal! h
  return getpos('.')
endfunction
"}}}
function! s:get_right_pos(pos) abort  "{{{
  call setpos('.', a:pos)
  normal! l
  return getpos('.')
endfunction
"}}}
function! s:check_edges(head, tail, patterns) abort  "{{{
  if a:patterns[0] ==# '' || a:patterns[1] ==# '' | return s:null_4pos | endif

  call setpos('.', a:head)
  let head1 = searchpos(a:patterns[0], 'c', a:tail[1])

  if head1 != a:head[1:2] | return s:null_4pos | endif

  call setpos('.', a:tail)
  let tail2 = s:searchpos_bce(a:tail, a:patterns[1], a:head[1])

  if tail2 != a:tail[1:2] | return s:null_4pos | endif

  let head2 = searchpos(a:patterns[1], 'bc', a:head[1])
  call setpos('.', a:head)
  let tail1 = searchpos(a:patterns[0], 'ce', a:tail[1])

  if head1 == s:null_coord || tail1 == s:null_coord
        \ || head2 == s:null_coord || tail2 == s:null_coord
        \ || s:is_equal_or_ahead(s:c2p(tail1), s:c2p(head2))
    return s:null_4pos
  endif

  let target = {
        \   'head1': head1, 'tail1': tail1,
        \   'head2': head2, 'tail2': tail2,
        \ }
  return map(target, 's:c2p(v:val)')
endfunction
"}}}
function! s:search_edges(head, tail, patterns) abort "{{{
  if a:patterns[0] ==# '' || a:patterns[1] ==# '' | return s:null_4pos | endif

  call setpos('.', a:head)
  let head1 = searchpos(a:patterns[0], 'c', a:tail[1])

  call setpos('.', a:tail)
  let tail2 = s:searchpos_bce(a:tail, a:patterns[1], a:head[1])

  if head1 == s:null_coord || tail2 == s:null_coord
        \ || s:is_equal_or_ahead(s:c2p(head1), s:c2p(tail2))
    return s:null_4pos
  endif

  let head2 = searchpos(a:patterns[1], 'bc', head1[0])
  call setpos('.', s:c2p(head1))
  let tail1 = searchpos(a:patterns[0], 'ce', head2[0])

  if tail1 == s:null_coord || head2 == s:null_coord
        \ || s:is_ahead(s:c2p(head1), s:c2p(tail1))
        \ || s:is_ahead(s:c2p(head2), s:c2p(tail2))
        \ || s:is_equal_or_ahead(s:c2p(tail1), s:c2p(head2))
    return s:null_4pos
  endif

  let target = {
        \   'head1': head1, 'tail1': tail1,
        \   'head2': head2, 'tail2': tail2,
        \ }
  return map(target, 's:c2p(v:val)')
endfunction
"}}}
function! s:get_patterns(candidate, opt_expr, opt_regex) abort "{{{
  if a:opt_expr
    return ['', '']
  endif

  let patterns = deepcopy(a:candidate.buns)
  if !a:opt_regex
    let patterns = map(patterns, 's:escape(v:val)')
  endif

  " substitute a break "\n" to a regular expression pattern '\n'
  let patterns = map(patterns, 'substitute(v:val, ''\n'', ''\\n'', ''g'')')
  return patterns
endfunction
"}}}
function! s:skip_space(head, tail) abort  "{{{
  " NOTE: This function is destructive, directly update a:head and a:tail.
  call setpos('.', a:head)
  if a:head[2] == col([a:head[1], '$'])
    " if the cursor is on a line breaking, it should not be skipped.
    let head = a:head
  else
    let head = s:c2p(searchpos('\_S', 'c', a:tail[1]))
  endif

  call setpos('.', a:tail)
  if a:tail[2] == 1
    let tail = a:tail
  else
    let tail = s:c2p(searchpos('\_S', 'bc', a:head[1]))
  endif

  if head != s:null_pos && tail != s:null_pos && s:is_equal_or_ahead(tail, head)
    let a:head[0:3] = head[0:3]
    let a:tail[0:3] = tail[0:3]
  endif
endfunction
"}}}
function! s:check_textobj_diff(head, tail, candidate, opt_noremap) abort  "{{{
  let target = deepcopy(s:null_4pos)
  let [textobj_i, textobj_a] = a:candidate.external
  let [visual_head, visual_tail] = [getpos("'<"), getpos("'>")]
  let visualmode = visualmode()

  if a:opt_noremap
    let cmd = 'normal!'
    let v   = 'v'
  else
    let cmd = 'normal'
    let v   = "\<Plug>(sandwich-v)"
  endif

  let order_list = [[1, a:head], [1, a:tail]]
  if has_key(a:candidate, 'excursus')
    let order_list = [a:candidate.excursus] + order_list
  endif

  " try twice (at least)
  let found = 0
  for [l:count, cursor] in order_list
    " get outer positions
    call setpos('.', cursor)
    execute printf('%s %s%d%s', cmd, v, l:count, textobj_a)
    execute "normal! \<Esc>"
    let motionwise_a = visualmode()
    let [target.head1, target.tail2] = [getpos("'<"), getpos("'>")]
    if target.head1 == cursor && target.tail2 == cursor
      let [target.head1, target.tail2] = [copy(s:null_coord), copy(s:null_coord)]
    elseif motionwise_a ==# 'V'
      let target.tail2[2] = col([target.tail2[1], '$'])
    endif

    " get inner positions
    call setpos('.', cursor)
    execute printf('%s %s%d%s', cmd, v, l:count, textobj_i)
    execute "normal! \<Esc>"
    let motionwise_i = visualmode()
    " FIXME: How should I treat a line breaking?
    let [target.tail1, target.head2] = s:get_wider_region(getpos("'<"), getpos("'>"))
    if target.tail1 == cursor && target.head2 == cursor
      let [target.tail1, target.head2] = [copy(s:null_coord), copy(s:null_coord)]
    elseif motionwise_i ==# 'V'
      let target.head2[2] = col([target.head2[1], '$'])
    endif
    if motionwise_i ==# "\<C-v>"
      normal! gv
      if getpos('.')[1] == target.head2[1]
        normal! O
        let target.tail1 = getpos('.')
        normal! o
        let target.head2 = getpos('.')
      else
        normal! O
        let target.head2 = getpos('.')
        normal! o
        let target.tail1 = getpos('.')
      endif
      execute "normal! \<Esc>"
      let [target.tail1, target.head2] = s:get_wider_region(target.tail1, target.head2)
    endif

    " check validity
    if target.head1 == a:head && target.tail2 == a:tail
          \ && target.tail1 != s:null_pos && target.head2 != s:null_pos
          \ && s:is_equal_or_ahead(target.tail1, target.head1)
          \ && s:is_equal_or_ahead(target.tail2, target.head2)
      let found = 1
      break
    endif
  endfor

  " restore visualmode
  execute 'normal! ' . visualmode . "\<Esc>"
  " restore marks
  call setpos("'<", visual_head)
  call setpos("'>", visual_tail)

  if found
    return target
  else
    return s:null_4pos
  endif
endfunction
"}}}
" function! s:searchpos_bce(curpos, pattern, stopline)  "{{{
if s:has_patch_7_4_771
  function! s:searchpos_bce(curpos, pattern, stopline) abort
    return searchpos(a:pattern, 'bce', a:stopline)
  endfunction
else
  " workaround for unicode string (because of a bug of vim)
  " If the cursor is on a unicode character(uc), searchpos(uc, 'bce', stopline) always returns [0, 0],
  " though searchpos(uc, 'bce') returns a correct value.
  function! s:searchpos_bce(curpos, pattern, stopline) abort
    if a:curpos[1] == line('$') && a:curpos[2] == col([line('$'), '$'])
      normal! h
      return searchpos(a:pattern, 'e', a:stopline)
    else
      normal! l
      return searchpos(a:pattern, 'be', a:stopline)
    endif
  endfunction
endif
"}}}

" position shifting
function! s:shift_for_add(shifted_pos, target, addition, indent, is_linewise) abort "{{{
  call s:push2(a:shifted_pos, a:target, a:addition, a:indent, a:is_linewise)
  call s:push1(a:shifted_pos, a:target, a:addition, a:indent, a:is_linewise)
  return a:shifted_pos
endfunction
"}}}
function! s:shift_for_delete(shifted_pos, target, deletion, is_linewise) abort  "{{{
  call s:pull2(a:shifted_pos, a:target, a:deletion, a:is_linewise)
  call s:pull1(a:shifted_pos, a:target, a:deletion, a:is_linewise)
  return a:shifted_pos
endfunction
"}}}
function! s:shift_for_replace(shifted_pos, target, addition, deletion, indent, is_linewise) abort "{{{
  if s:is_in_between(a:shifted_pos, a:target.head1, a:target.tail1)
    let startpos = copy(a:target.head1)
    let endpos   = copy(startpos)
    call s:push1(endpos, a:target, a:addition, a:indent, a:is_linewise)
    let endpos = s:get_left_pos(endpos)

    if s:is_equal_or_ahead(a:shifted_pos, endpos)
      let a:shifted_pos[0:3] = endpos
    endif
  elseif s:is_in_between(a:shifted_pos, a:target.head2, a:target.tail2)
    let startpos = copy(a:target.head2)
    call s:pull1(startpos, a:target, a:deletion, a:is_linewise)
    call s:push1(startpos, a:target, a:addition, a:indent, a:is_linewise)
    let endpos = copy(startpos)
    let target = copy(s:null_4pos)
    let target.head2 = copy(startpos)
    call s:push2(endpos, target, a:addition, a:indent, a:is_linewise)
    let endpos = s:get_left_pos(endpos)

    call s:pull1(a:shifted_pos, a:target, a:deletion, a:is_linewise)
    call s:push1(a:shifted_pos, a:target, a:addition, a:indent, a:is_linewise)

    if s:is_equal_or_ahead(a:shifted_pos, endpos)
      let a:shifted_pos[0:3] = endpos
    endif
  else
    call s:pull2(a:shifted_pos, a:target, a:deletion, a:is_linewise)
    if a:is_linewise[1]
      let a:target.head2[1] -= 1
    endif
    call s:push2(a:shifted_pos, a:target, a:addition, a:indent, a:is_linewise)
    if a:is_linewise[1]
      let a:target.head2[1] += 1
    endif
    call s:pull1(a:shifted_pos, a:target, a:deletion, a:is_linewise)
    if a:is_linewise[0]
      let a:target.head1[1] -= 1
    endif
    call s:push1(a:shifted_pos, a:target, a:addition, a:indent, a:is_linewise)
    if a:is_linewise[0]
      let a:target.head1[1] += 1
    endif
  endif
  return a:shifted_pos
endfunction
"}}}
function! s:push1(shifted_pos, target, addition, indent, is_linewise) abort  "{{{
  if a:shifted_pos != s:null_pos
    let shift = [0, 0, 0, 0]
    let head  = a:target.head1

    if a:is_linewise[0] && a:shifted_pos[1] >= head[1]
      " lnum
      let shift[1] += 1
    endif

    if s:is_equal_or_ahead(a:shifted_pos, head) || (a:is_linewise[0] && a:shifted_pos[1] == head[1])
      call s:push(shift, a:shifted_pos, head, a:addition[0], a:indent[0], a:is_linewise[0])
    endif
    let a:shifted_pos[1:2] += shift[1:2]
  endif
  return a:shifted_pos
endfunction
"}}}
function! s:push2(shifted_pos, target, addition, indent, is_linewise) abort  "{{{
  if a:shifted_pos != s:null_pos
    let shift = [0, 0, 0, 0]
    let head  = a:target.head2

    if a:is_linewise[1] && a:shifted_pos[1] > head[1]
      " lnum
      let shift[1] += 1
    endif

    if s:is_equal_or_ahead(a:shifted_pos, head)
      call s:push(shift, a:shifted_pos, head, a:addition[1], a:indent[1], a:is_linewise[1])
    endif
    let a:shifted_pos[1:2] += shift[1:2]
  endif
  return a:shifted_pos
endfunction
"}}}
function! s:push(shift, shifted_pos, head, addition, indent, is_linewise) abort  "{{{
  let addition = split(a:addition, '\n', 1)

  " lnum
  let a:shift[1] += len(addition) - 1
  " column
  if !a:is_linewise && a:head[1] == a:shifted_pos[1]
    let a:shift[2] += strlen(addition[-1])
    if len(addition) > 1
      let a:shift[2] -= a:head[2] - 1
      let a:shift[2] += a:indent - strlen(matchstr(addition[-1], '^\s*'))
    endif
  endif
endfunction
"}}}
function! s:pull1(shifted_pos, target, deletion, is_linewise) abort "{{{
  if a:shifted_pos != s:null_pos
    let shift  = [0, 0, 0, 0]
    let head   = a:target.head1
    let tail   = a:target.tail1

    " lnum
    if a:shifted_pos[1] > head[1]
      if a:shifted_pos[1] <= tail[1]
        let shift[1] -= a:shifted_pos[1] - head[1]
      else
        let shift[1] -= tail[1] - head[1]
      endif
    endif
    " column
    if s:is_ahead(a:shifted_pos, head) && a:shifted_pos[1] <= tail[1]
      if s:is_ahead(a:shifted_pos, tail)
        let shift[2] -= strlen(split(a:deletion[0], '\n', 1)[-1])
        let shift[2] += head[1] != a:shifted_pos[1] ? head[2] - 1 : 0
      else
        let shift[2] -= a:shifted_pos[2]
        let shift[2] += head[2]
      endif
    endif

    let a:shifted_pos[1] += shift[1]

    " the case for linewise action
    if a:is_linewise[0]
      if a:shifted_pos[1] == head[1]
        " col
        let a:shifted_pos[2] = 0
      endif
      if a:shifted_pos[1] > head[1]
        " lnum
        let a:shifted_pos[1] -= 1
      endif
    endif

    if a:shifted_pos[2] == 0
      let a:shifted_pos[2] = 1
    elseif a:shifted_pos[2] == 1/0
      let a:shifted_pos[2]  = col([a:shifted_pos[1], '$']) - 1
      let a:shifted_pos[2] += shift[2]
    else
      let a:shifted_pos[2] += shift[2]
    endif
  endif
  return a:shifted_pos
endfunction
"}}}
function! s:pull2(shifted_pos, target, deletion, is_linewise) abort "{{{
  if a:shifted_pos != s:null_pos
    let shift  = [0, 0, 0, 0]
    let head   = a:target.head2
    let tail   = a:target.tail2

    " lnum
    if a:shifted_pos[1] >= head[1]
      if a:shifted_pos[1] < tail[1]
        let shift[1] -= a:shifted_pos[1] - head[1]
      else
        let shift[1] -= tail[1] - head[1]
      endif
    endif
    " column
    if s:is_equal_or_ahead(a:shifted_pos, head) && a:shifted_pos[1] <= tail[1]
      if s:is_ahead(a:shifted_pos, tail)
        let shift[2] -= strlen(split(a:deletion[1], '\n', 1)[-1])
        let shift[2] += head[1] != a:shifted_pos[1] ? head[2] - 1 : 0
      else
        let shift[2] -= a:shifted_pos[2] + 1
        let shift[2] += head[2]
      endif
    endif
    let a:shifted_pos[1:2] += shift[1:2]

    " the case for linewise action
    if a:is_linewise[1]
      if a:shifted_pos[1] == head[1]
        " col
        let a:shifted_pos[2]  = 1/0
      endif
      if a:shifted_pos[1] >= head[1]
        " lnum
        let a:shifted_pos[1] -= 1
      endif
    endif
  endif
  return a:shifted_pos
endfunction
"}}}

" get and set displayed coordinates
function! s:get_displaycoord(pos) abort "{{{
  let [lnum, col, offset] = a:pos[1:3]

  if [lnum, col] != s:null_coord
    if col == 1
      let disp_col = 1
    else
      let disp_col = strdisplaywidth(getline(lnum)[: col - 2]) + 1 + offset
    endif
  else
    let disp_col = 0
  endif
  return [lnum, disp_col]
endfunction
"}}}
function! s:set_displaycoord(disp_coord) abort "{{{
  if a:disp_coord != s:null_coord
    execute 'normal! ' . a:disp_coord[0] . 'G' . a:disp_coord[1] . '|'
  endif
endfunction
"}}}

" miscellaneous
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
function! s:get_cursorchar(pos) abort "{{{
  let reg = ['"', getreg('"'), getregtype('"')]
  try
    call setpos('.', a:pos)
    normal! yl
    let c = @@
  finally
    call call('setreg', reg)
  endtry
  return c
endfunction
"}}}
function! s:get_buf_length(start, end) abort  "{{{
  if a:start[1] == a:end[1]
    let len = a:end[2] - a:start[2] + 1
  else
    let length_list = map(getline(a:start[1], a:end[1]), 'len(v:val) + 1')
    let idx = 0
    let accumm_length = 0
    let accumm_list   = [0]
    for length in length_list[1:]
      let accumm_length  = accumm_length + length_list[idx]
      let accumm_list   += [accumm_length]
      let idx += 1
    endfor
    let len = accumm_list[a:end[1] - a:start[1]] + a:end[2] - a:start[2] + 1
  endif
  return len
endfunction
"}}}
function! s:c2p(coord) abort  "{{{
  return [0] + a:coord + [0]
endfunction
"}}}
function! s:is_valid_2pos(pos) abort  "{{{
  " NOTE: This function do not check the geometric relationships.
  "       It should be checked by s:is_ahead or s:is_equal_or_ahead
  "       separately.
  return a:pos.head != s:null_pos && a:pos.tail != s:null_pos
endfunction
"}}}
function! s:is_valid_4pos(pos) abort  "{{{
  " NOTE: This function do not check the geometric relationships.
  "       It should be checked by s:is_ahead or s:is_equal_or_ahead
  "       separately.
  return a:pos.head1 != s:null_pos && a:pos.tail1 != s:null_pos
    \ && a:pos.head2 != s:null_pos && a:pos.tail2 != s:null_pos
endfunction
"}}}
function! s:is_ahead(pos1, pos2) abort  "{{{
  return a:pos1[1] > a:pos2[1] || (a:pos1[1] == a:pos2[1] && a:pos1[2] > a:pos2[2])
endfunction
"}}}
function! s:is_equal_or_ahead(pos1, pos2) abort  "{{{
  return a:pos1[1] > a:pos2[1] || (a:pos1[1] == a:pos2[1] && a:pos1[2] >= a:pos2[2])
endfunction
"}}}
function! s:is_in_between(pos, head, tail) abort  "{{{
  return (a:pos != s:null_pos) && (a:head != s:null_pos) && (a:tail != s:null_pos)
    \  && ((a:pos[1] > a:head[1]) || ((a:pos[1] == a:head[1]) && (a:pos[2] >= a:head[2])))
    \  && ((a:pos[1] < a:tail[1]) || ((a:pos[1] == a:tail[1]) && (a:pos[2] <= a:tail[2])))
endfunction
"}}}
function! s:get(name, default) abort  "{{{
  return get(g:, 'operator#sandwich#' . a:name, a:default)
endfunction
"}}}
function! s:escape(string) abort  "{{{
  return escape(a:string, '~"\.^$[]*')
endfunction
"}}}
function! s:eval(expr, ...) abort "{{{
  if type(a:expr) == s:type_fref
    return call(a:expr, a:000)
  else
    return eval(a:expr)
  endif
endfunction
"}}}
" function! s:shortest(list) abort  "{{{
if s:has_patch_7_4_358
  function! s:shortest(list) abort
    call map(a:list, '[v:val, s:get_buf_length(v:val.head1, v:val.tail2)]')
    call sort(a:list, 's:compare_buf_length')
    return a:list[0][0]
  endfunction

  function! s:compare_buf_length(i1, i2) abort
    return a:i2[1] - a:i1[1]
  endfunction
else
  function! s:shortest(list) abort
    call map(a:list, '[v:val, s:get_buf_length(v:val.head1, v:val.tail2)]')
    let len = len(a:list)
    let min = len - 1
    if len - 2 >= 0
      for i in range(len - 2, 0, -1)
        if a:list[min][1] >= a:list[i][1]
          let min = i
        endif
      endfor
    endif
    return a:list[min][0]
  endfunction
endif
"}}}

" recipes "{{{
function! operator#sandwich#get_recipes() abort  "{{{
  let default = exists('g:operator#sandwich#no_default_recipes')
            \ ? [] : g:operator#sandwich#default_recipes
  return deepcopy(s:get('recipes', default))
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
      \   'cursor'     : 'inner_head',
      \   'query_once' : 0,
      \   'expr'       : 0,
      \   'noremap'    : 1,
      \   'skip_space' : 0,
      \   'highlight'  : 1,
      \   'command'    : [],
      \   'linewise'   : 0,
      \   'autoindent' : -1,
      \   'indentkeys' : '',
      \   'indentkeys+': '',
      \   'indentkeys-': '',
      \ }
let s:default_opt.add.line = {
      \   'cursor'    : 'inner_head',
      \   'query_once': 0,
      \   'expr'      : 0,
      \   'noremap'   : 1,
      \   'skip_space': 1,
      \   'highlight' : 1,
      \   'command'   : [],
      \   'linewise'  : 1,
      \   'autoindent' : -1,
      \   'indentkeys' : '',
      \   'indentkeys+': '',
      \   'indentkeys-': '',
      \ }
let s:default_opt.add.block = {
      \   'cursor'    : 'inner_head',
      \   'query_once': 0,
      \   'expr'      : 0,
      \   'noremap'   : 1,
      \   'skip_space': 1,
      \   'highlight' : 1,
      \   'command'   : [],
      \   'linewise'  : 0,
      \   'autoindent' : -1,
      \   'indentkeys' : '',
      \   'indentkeys+': '',
      \   'indentkeys-': '',
      \ }
let s:default_opt.add.filter = printf('v:key =~# ''\%%(%s\)''', join(keys(s:default_opt['add']['char']), '\|'))

let s:default_opt.delete = {}
let s:default_opt.delete.char = {
      \   'cursor'    : 'inner_head',
      \   'noremap'   : 1,
      \   'regex'     : 0,
      \   'skip_space': 1,
      \   'skip_char' : 0,
      \   'highlight' : 1,
      \   'command'   : [],
      \   'linewise'  : 0,
      \ }
let s:default_opt.delete.line = {
      \   'cursor'    : 'inner_head',
      \   'noremap'   : 1,
      \   'regex'     : 0,
      \   'skip_space': 2,
      \   'skip_char' : 0,
      \   'highlight' : 1,
      \   'command'   : [],
      \   'linewise'  : 1,
      \ }
let s:default_opt.delete.block = {
      \   'cursor'    : 'inner_head',
      \   'noremap'   : 1,
      \   'regex'     : 0,
      \   'skip_space': 1,
      \   'skip_char' : 0,
      \   'highlight' : 1,
      \   'command'   : [],
      \   'linewise'  : 0,
      \ }
let s:default_opt.delete.filter = printf('v:key =~# ''\%%(%s\)''', join(keys(s:default_opt['delete']['char']), '\|'))

let s:default_opt.replace = {}
let s:default_opt.replace.char = {
      \   'cursor'    : 'inner_head',
      \   'query_once': 0,
      \   'regex'     : 0,
      \   'expr'      : 0,
      \   'noremap'   : 1,
      \   'skip_space': 1,
      \   'skip_char' : 0,
      \   'highlight' : 1,
      \   'command'   : [],
      \   'linewise'  : 0,
      \   'autoindent' : -1,
      \   'indentkeys' : '',
      \   'indentkeys+': '',
      \   'indentkeys-': '',
      \ }
let s:default_opt.replace.line = {
      \   'cursor'    : 'inner_head',
      \   'query_once': 0,
      \   'regex'     : 0,
      \   'expr'      : 0,
      \   'noremap'   : 1,
      \   'skip_space': 2,
      \   'skip_char' : 0,
      \   'highlight' : 1,
      \   'command'   : [],
      \   'linewise'  : 0,
      \   'autoindent' : -1,
      \   'indentkeys' : '',
      \   'indentkeys+': '',
      \   'indentkeys-': '',
      \ }
let s:default_opt.replace.block = {
      \   'cursor'    : 'inner_head',
      \   'query_once': 0,
      \   'regex'     : 0,
      \   'expr'      : 0,
      \   'noremap'   : 1,
      \   'skip_space': 1,
      \   'skip_char' : 0,
      \   'highlight' : 1,
      \   'command'   : [],
      \   'linewise'  : 0,
      \   'autoindent' : -1,
      \   'indentkeys' : '',
      \   'indentkeys+': '',
      \   'indentkeys-': '',
      \ }
let s:default_opt.replace.filter = printf('v:key =~# ''\%%(%s\)''', join(keys(s:default_opt['replace']['char']), '\|'))

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
  if !(a:kind ==# 'add' || a:kind ==# 'delete' || a:kind ==# 'replace' || a:kind ==# 'all')
    echohl WarningMsg
    echomsg 'Invalid kind "' . a:kind . '".'
    echohl NONE
    return
  endif

  if !(a:motionwise ==# 'char' || a:motionwise ==# 'line' || a:motionwise ==# 'block' || a:motionwise ==# 'all')
    echohl WarningMsg
    echomsg 'Invalid motion-wise "' . a:motionwise . '".'
    echohl NONE
    return
  endif

  if a:kind !=# 'all' && a:motionwise !=# 'all'
    if filter(keys(s:default_opt[a:kind][a:motionwise]), 'v:val ==# a:option') == []
      echohl WarningMsg
      echomsg 'Invalid option name "' . a:option . '".'
      echohl NONE
      return
    endif

    if type(a:value) != type(s:default_opt[a:kind][a:motionwise][a:option])
      echohl WarningMsg
      echomsg 'Invalid type of value. ' . string(a:value)
      echohl NONE
      return
    endif
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

  for kind in kinds
    for motionwise in motionwises
      if filter(keys(s:default_opt[kind][motionwise]), 'v:val ==# a:option') != []
            \ && type(a:value) == type(s:default_opt[kind][motionwise][a:option])
        let g:operator#sandwich#options[kind][motionwise][a:option] = a:value
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
