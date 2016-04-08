" operator object - controlling a whole operation

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
let s:type_fref = type(function('tr'))

" patchs
if v:version > 704 || (v:version == 704 && has('patch237'))
  let s:has_patch_7_4_310 = has('patch-7.4.310')
else
  let s:has_patch_7_4_310 = v:version == 704 && has('patch310')
endif

" features
let s:has_gui_running = has('gui_running')
"}}}

function! operator#sandwich#operator#new() abort  "{{{
  return deepcopy(s:operator)
endfunction
"}}}

" s:operator "{{{
let s:operator = {
      \   'state'     : 0,
      \   'kind'      : '',
      \   'count'     : 1,
      \   'n'         : 0,
      \   'mode'      : 'n',
      \   'view'      : {},
      \   'blockwidth': 0,
      \   'extended'  : 0,
      \   'keepable'  : 0,
      \   'at_work'   : 0,
      \   'opt'       : {},
      \   'basket'    : [],
      \   'recipes'   : {
      \     'arg'       : [],
      \     'synchro'   : [],
      \     'integrated': [],
      \     'dog_ear'   : [],
      \   },
      \   'cursor': {
      \     'head'      : copy(s:null_pos),
      \     'inner_head': copy(s:null_pos),
      \     'keep'      : copy(s:null_pos),
      \     'inner_tail': copy(s:null_pos),
      \     'tail'      : copy(s:null_pos),
      \     'default'   : copy(s:null_pos),
      \   },
      \   'modmark': copy(s:null_2pos),
      \ }
"}}}
function! s:operator.execute(kind, motionwise) dict abort  "{{{
  " FIXME: What is the best practice to handle exceptions?
  "        Serious lack of the experience with error handlings...
  let errormsg = ''
  let options = s:shift_options(a:kind, self.mode)
  try
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
function! s:operator.initialize(kind, motionwise) dict abort "{{{
  call self.recipes.integrate(a:kind, a:motionwise, self.mode)
  let region = s:get_assigned_region(a:kind, a:motionwise)
  let region_list = a:motionwise ==# 'block' ? self.split(region) : [region]
  if region == s:null_2pos
    " deactivate
    let self.state = -1
  endif

  let self.n = len(region_list)  " Number of lines in the target region
  let self.at_work = 1
  let self.cursor.inner_head = deepcopy(region.head)
  let self.cursor.inner_tail = deepcopy(region.tail)
  let option_dict = get(b:, 'operator_sandwich_options', g:operator#sandwich#options)
  call self.opt.update('default', option_dict[a:kind][a:motionwise])

  if self.state
    let self.basket = map(range(self.n), 'operator#sandwich#stuff#new()')
  else
    let self.view = winsaveview()
    let self.modmark.head = copy(s:null_pos)
    let self.modmark.tail = copy(s:null_pos)
    call self.fill()
  endif
  for stuff in self.basket
    call stuff.initialize(self.cursor, self.modmark, self.count)
  endfor

  " set initial values
  for i in range(self.n)
    let stuff = self.basket[i]
    let stuff.edges = region_list[i]
  endfor
endfunction
"}}}
function! s:operator.split(region) dict abort  "{{{
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
function! s:operator.fill() dict abort  "{{{
  let lack = self.n - len(self.basket)
  if lack > 0
    let fillings = map(range(lack), 'operator#sandwich#stuff#new()')
    for stuff in fillings
      call stuff.initialize(self.cursor, self.modmark, self.count)
    endfor
  endif
endfunction
"}}}
function! s:operator.add() dict abort "{{{
  let opt = self.opt
  let opt_highlight = opt.of('highlight', '')
  let hi_group = opt_highlight >= 2 ? 'OperatorSandwichStuff' : 'OperatorSandwichBuns'

  for i in range(self.count)
    call self.set_target()
    if self.state
      " query preferable buns
      call winrestview(self.view)
      call self.show('stuff', hi_group)
      try
        let recipe = self.query()
        let self.recipes.dog_ear += [recipe]
      finally
        call self.quench('stuff')
      endtry

      call opt.update('recipe_add', recipe)
      if i == 0 && self.count > 1 && opt.of('query_once')
        call self.recipes.fill(recipe, self.count)
        let self.state = 0
      endif
    else
      let recipe = self.recipes.dog_ear[i]
      call opt.update('recipe_add', recipe)
    endif
    if !has_key(recipe, 'buns') || recipe.buns == []
      break
    endif

    call self.skip_space(i)
    call self.add_once(i, recipe)
    let undojoin = self.state ? 1 : 0
    call opt.clear('recipe_add')
  endfor

  if opt_highlight >= 3
    let hi_duration = s:get('highlight_duration', 200)
    call self.blink('added', 'OperatorSandwichAdd', hi_duration)
  endif
endfunction
"}}}
function! s:operator.add_once(i, recipe) dict abort  "{{{
  let buns = s:get_buns(a:recipe, self.opt.of('expr'))
  let undojoin = a:i == 0 || self.state == 0 ? 0 : 1
  let modified = 0
  if buns[0] !=# '' || buns[1] !=# ''
    for j in range(self.n)
      let stuff = self.basket[j]
      if stuff.active
        let act = stuff.acts[a:i]
        let act.opt = deepcopy(self.opt)
        let added = act.add_pair(buns, stuff, undojoin)

        if added != {}
          let success = 1
          let stuff.added += [added]
        else
          let success = 0
        endif

        let undojoin = success ? 0 : undojoin
        let modified = modified || success
      endif
    endfor

    if modified
      let self.cursor.head = copy(self.modmark.head)
      let self.cursor.tail = s:get_left_pos(self.modmark.tail)
    endif
  endif
endfunction
"}}}
function! s:operator.delete() dict abort  "{{{
  let hi_exited = 0
  let opt_highlight = self.opt.of('highlight', '')
  let hi_duration = s:get('highlight_duration', 200)
  let hi_group = opt_highlight >= 2 ? 'OperatorSandwichDelete' : 'OperatorSandwichBuns'
  for i in range(self.count)
    if !self.match(i)
      break
    endif

    if opt_highlight && !hi_exited && hi_duration > 0
      call winrestview(self.view)
      let hi_exited = self.blink('target', hi_group, hi_duration, self.opt.of('linewise'))
    endif

    call self.delete_once(i)
  endfor
endfunction
"}}}
function! s:operator.delete_once(i) dict abort "{{{
  let modified = 0
  for j in range(self.n)
    let stuff = self.basket[j]
    if stuff.active
      let act = stuff.acts[a:i]
      let success = act.delete_pair(stuff, modified)
      let modified = modified || success
    endif
  endfor

  if modified
    let self.cursor.head = copy(self.modmark.head)
    let self.cursor.tail = s:get_left_pos(self.modmark.tail)
  endif
endfunction
"}}}
function! s:operator.replace() dict abort  "{{{
  let opt = self.opt
  let opt_highlight = opt.of('highlight', '')
  let hi_group = opt_highlight >= 2 ? 'OperatorSandwichDelete' : 'OperatorSandwichBuns'
  let self.cursor.inner_head = copy(s:null_pos)
  let self.cursor.inner_tail = copy(s:null_pos)

  let undojoin = 0
  for i in range(self.count)
    if !self.match(i)
      break
    endif

    if self.state
      " query preferable buns
      call winrestview(self.view)
      call self.show('target', hi_group)
      try
        let recipe = self.query()
        let self.recipes.dog_ear += [recipe]
      finally
        call self.quench('target')
      endtry

      call opt.update('recipe_add', recipe)
      if i == 0 && self.count > 1 && opt.of('query_once')
        call self.recipes.fill(recipe, self.count)
        let self.state = 0
      endif
    else
      let recipe = self.recipes.dog_ear[i]
      call opt.update('recipe_add', recipe)
    endif
    if !has_key(recipe, 'buns') || recipe.buns == []
      break
    endif

    call self.replace_once(i, recipe)
    let undojoin = self.state ? 1 : 0
    call opt.clear('recipe_add')
  endfor

  if opt_highlight >= 3
    let hi_duration = s:get('highlight_duration', 200)
    call self.blink('added', 'OperatorSandwichAdd', hi_duration)
  endif
endfunction
"}}}
function! s:operator.replace_once(i, recipe) dict abort  "{{{
  let buns = s:get_buns(a:recipe, self.opt.of('expr'))
  let undojoin = a:i == 0 || self.state == 0 ? 0 : 1
  let modified = 0
  for j in range(self.n)
    let stuff = self.basket[j]
    if stuff.active
      let act = stuff.acts[a:i]
      call act.opt.update('recipe_add', a:recipe)
      let added = act.replace_pair(buns, stuff, undojoin, modified)

      if added != {}
        let success = 1
        let stuff.added += [added]
      else
        let success = 0
      endif

      let undojoin = success ? 0 : undojoin
      let modified = modified || success
    endif
  endfor

  if modified
    let self.cursor.head = copy(self.modmark.head)
    let self.cursor.tail = s:get_left_pos(self.modmark.tail)
  endif
endfunction
"}}}
function! s:operator.set_target() dict abort  "{{{
  for i in range(self.n)
    let stuff = self.basket[i]
    call stuff.set_target()
  endfor
endfunction
"}}}
function! s:operator.skip_space(i) dict abort "{{{
  let opt = self.opt
  if a:i == 0 && opt.of('skip_space')
    " skip space only in the first count.
    for j in range(self.n)
      let stuff = self.basket[j]
      call stuff.skip_space()
      call stuff.set_target()
    endfor

    " for cursor positions
    if !opt.of('linewise')
      let top_stuff = self.basket[self.n-1]
      let bot_stuff = self.basket[0]
      let self.cursor.inner_head = deepcopy(top_stuff.edges.head)
      let self.cursor.inner_tail = deepcopy(bot_stuff.edges.tail)
    endif
  endif
endfunction
"}}}
function! s:operator.query() dict abort  "{{{
  let filter = 'has_key(v:val, "buns")
          \ && (!has_key(v:val, "regex") || !v:val.regex)
          \ && s:has_action(v:val, "add")'
  let recipes = filter(deepcopy(self.recipes.integrated), filter)
  let opt = self.opt
  let clock = sandwich#clock#new()
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
  return extend(recipe, {'evaluated': 0})
endfunction
"}}}
function! s:operator.match(i) dict abort  "{{{
  let filter  = 's:has_action(v:val, "delete")'
  let recipes = filter(deepcopy(self.recipes.integrated), filter)

  " uniq recipes
  let opt = self.opt
  call s:uniq_recipes(recipes, opt.of('regex'), opt.get('expr', 'recipe_delete', 0), opt.of('noremap', 'recipe_delete'))

  let success = 0
  for j in range(self.n)
    let stuff = self.basket[j]
    let act = stuff.acts[a:i]
    let act.opt = deepcopy(self.opt)
    let success = stuff.match(recipes, act.opt) || success
  endfor
  return success
endfunction
"}}}
function! s:operator.show(place, hi_group, ...) dict abort "{{{
  let force = get(a:000, 1, 0)
  let success = 0
  if self.opt.of('highlight') || force
    let linewise = get(a:000, 0, 0)
    for i in range(self.n)
      let stuff = self.basket[i]
      let success = stuff.show(a:place, a:hi_group, linewise) || success
    endfor
    redraw
  endif
  return !success
endfunction
"}}}
function! s:operator.quench(place, ...) dict abort "{{{
  let force = get(a:000, 0, 0)
  let success = 0
  if self.opt.of('highlight') || force
    for i in range(self.n)
      let stuff = self.basket[i]
      let success = stuff.quench(a:place) || success
    endfor
  endif
  return !success
endfunction
"}}}
function! s:operator.blink(place, hi_group, duration, ...) dict abort "{{{
  if self.opt.of('highlight')
    let clock = sandwich#clock#new()
    let hi_exited = 0
    let linewise = get(a:000, 0, 0)

    call self.show(a:place, a:hi_group, linewise)
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
        call feedkeys(c, 't')
      endif
    finally
      call self.quench(a:place)
      call clock.stop()
      return hi_exited
    endtry
  endif
endfunction
"}}}
function! s:operator.finalize(kind) dict abort  "{{{
  if self.state >= 0
    " restore view
    if self.view != {}
      call winrestview(self.view)
      let self.view = {}
    endif

    let act = self.last_succeeded()
    if act != {}
      " set modified marks
      let modmark = self.modmark
      if modmark.head != s:null_pos && modmark.tail != s:null_pos
            \ && s:is_equal_or_ahead(modmark.tail, modmark.head)
        call setpos("'[", modmark.head)
        call setpos("']", modmark.tail)
      endif

      " set cursor position
      let cursor_opt = act.opt.of('cursor')
      if self.keepable
        let self.keepable = 0
      else
        " In the case of dot repeat, it is impossible to keep original position
        " unless self.keepable == 1.
        let self.cursor.keep = copy(self.cursor.default)
      endif
      let self.cursor.default = s:get_default_cursor_pos(self.cursor.inner_head)
      let cursor = get(self.cursor, cursor_opt, 'default')
      if cursor == s:null_pos
        let cursor = self.cursor.default
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
  let self.at_work = 0
endfunction
"}}}
function! s:operator.last_succeeded() abort "{{{
  for i in range(self.count - 1, 0, -1)
    for j in range(self.n)
      let stuff = self.basket[j]
      let act = stuff.acts[i]
      if act.success
        return act
      endif
    endfor
  endfor
  return {}
endfunction
"}}}
function! s:operator.recipes.integrate(kind, motionwise, mode) dict abort  "{{{
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
function! s:operator.recipes.fill(recipe, count) dict abort  "{{{
  while len(self.dog_ear) < a:count
    call add(self.dog_ear, a:recipe)
  endwhile
endfunction
"}}}

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

" private functions
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
function! s:get_buns(recipe, opt_expr) abort  "{{{
  if a:opt_expr == 2
    let buns = deepcopy(a:recipe.buns)
    let buns[0] = eval(buns[0])
    let buns[1] = eval(buns[1])
  elseif a:opt_expr == 1 && !a:recipe.evaluated
    let buns = a:recipe.buns
    let buns[0] = eval(buns[0])
    let buns[1] = eval(buns[1])
    let a:recipe.evaluated = 1
  else
    let buns = a:recipe.buns
  endif
  return buns
endfunction
"}}}
function! s:get_default_cursor_pos(inner_head) abort  "{{{
  call setpos('.', a:inner_head)
  let default = searchpos('^\s*\zs\S', 'cn', a:inner_head[1])
  return default == s:null_coord ? a:inner_head : s:c2p(default)
endfunction
"}}}

let [s:get_left_pos, s:c2p, s:is_valid_2pos, s:is_ahead, s:is_equal_or_ahead, s:get]
      \ = operator#sandwich#lib#funcref(['get_left_pos', 'c2p', 'is_valid_2pos', 'is_ahead', 'is_equal_or_ahead', 'get'])


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
