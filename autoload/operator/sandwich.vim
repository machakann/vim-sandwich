" operator-sandwich: wrap by buns!
" TODO: Add 'at' option
" TODO: Give API to get information from operator object.
"       It would be helpful for users in use of 'expr_filter' and 'command' option.


""" NOTE: Whole design (-: string or number, *: functions, []: list, {}: dictionary) "{{{
" operator object
"   - state                  : 0 or 1 or -1. If it is called by keymapping, it is 1. If it is called by dot command, it is 0. -1 is used in order to deactivate the operaor object when the assigned region is not valid.
"   - count                  : Positive integer. The assigned {count}
"   - num                    : The number of processed regions in one count. It could be more than 1 only in block wise visual mode.
"   - mode                   : 'n' or 'x'. Which mode the keymapping is called.
"   - blockwidth             : The width of selected region in blockwise visual mode.
"   - extended               : 0 or 1. If it is called in blockwise visual mode with extending the terminal edges to line ends, then 1. Otherwise 0
"   - keepable               : 0 or 1. If 1, 'keep' of 'cursor' local option is valid also in dot repeating.
"   {}view                   : The dictionary to restore the view when the operarion starts.
"   {}recipes
"     []arg                  : The recipes which are forced to be used given through the 4th argument of operator#sandwich#prerequisite().
"     []synchro              : The recipes which are used for the cooperation with textobj-sandwich. It works only on delete and replace action.
"     []integrated           : The recipes which are the integrated result of all recipes. This is the one used practically.
"     * integrate            : The function to set operator.recipes.integrated.
"   {}cursor                 : [Linked from stuff.cursor] The infomation to set the final position of the cursor
"     []head                 : The head of the inserted head-surrounding.
"     []inner_head           : The left upper edge of the assigned region. It is used in default
"     []keep                 : The original position of the cursor. This is not valid when it started by dot command.
"     []inner_tail           : The right bottom edge of the assigned region.
"     []tail                 : The tail of the inserted tail-surrounding.
"   {}modmark                : [Linked from stuff.modmark] The positions of both edges of the modified region.
"   {}opt
"     {}arg                  : [Linked from stuff.opt.arg] The options given through the 3rd argument of operator#sandwich#prerequisite(). This has higher priority than default.
"       * clear              : The function to clear the containts.
"       * update             : The function to update the containts.
"     {}default              : [Linked from stuff.opt.default] The default options
"       * clear              : The function to clear the containts.
"       * update             : The function to update the containts.
"   []basket                 : The list holding information and histories for the action.
"     {}stuff
"       []buns               : The list consisted of two strings to add to/replace the edges.
"       - num                : The number of processed regions in one count. It could be more than 1 only in block wise visual mode.
"       - done               : If the stuff has been processed properly then 1, otehrwise 0.
"       {}cursor             : [Linked from act.cursor] Linked to operator.cursor.
"       {}modmark            : [Linked from act.modmark] Linked to operator.modmark.
"       {}clock              : The object to measure the time.
"         - started          : If the stopwatch has started, then 1. Otherwise 0.
"         - paused           : If the stopwatch has paused, then 1. Otherwise 0.
"         - losstime         : The elapsed time in paused periods.
"         []zerotime         : The time to start the measurement.
"         []pause_at         : The time to start temporal pause.
"         * start            : The function to start the stopwatch.
"         * pause            : The function to pause the stopwatch.
"         * elapsed          : The function to check the elapsed time from zerotime substituting losstime.
"         * stop             : The function to stop the measurement.
"       {}opt                : [Linked from act.opt]
"         - filter           : A strings for integrate() function to filter out redundant options.
"         {}default          : Linked to operator.opt.default.
"         {}arg              : Linked to operator.opt.arg.
"         {}recipe           : The copy of a snippet of recipe. But 'buns' is removed.
"           * clear          : The function to clear the containts.
"           * update         : The function to update the containts.
"         {}integrated       : The integrated options which is used in practical use.
"           * clear          : The function to clear the containts.
"           * update         : The function to update the containts.
"         * integrate        : The function that integrates three options (arg, recipe, default) to get 'integrated'.
"       []acts
"         {}act              : The information and functions to execute an action.
"           {}region         : The both edges of processed region.
"           {}target         : The target position to process.
"           {}cursor         : Linked to stuff.cursor
"           {}modmark        : Linked to stuff.modmark
"           {}indent         : Informations to save and restore autoindent features.
"           {}opt            : Linked to stuff.opt
"           * add_once       : The function to execute an adding action.
"           * delete_once    : The function to execute an delete action.
"           * replace_once   : The function to execute an replace action.
"           * search         : The function to search target position.
"       * query              : The function to ask users to determine which 'buns' to use.
"       * command            : The function to execute commands after an count. It is used if opt.integrated.commands is not empty.
"   * execute                : The function to start operation.
"   * initialize             : The function to initialize.
"   * split                  : The function to split the region for the blockwise case.
"   * {add, delete, replace} : Functions to execute shared processes in each kind of operations.
"   * finalize               : The function to set modified marks after all operations.
"}}}
""" NOTE: Presumable Errors list  "{{{
" Handled in s:doautcmd()
"   --> Some error in doautocmd.
"
" Handled in s:restview()
"   --> Could not restore tabpage or window after doautocmd.
"
" OperatorSandwichError:Add:ReadOnly
" OperatorSandwichError:Delete:ReadOnly
" OperatorSandwichError:Replace:ReadOnly
"   --> Catch E21 in editing.
"
" Others are converted to OperatorSandwichError:Unknown. It should not be observed.
"}}}

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
  let operator       = g:operator#sandwich#object
  let operator.state = 1
  let operator.count = a:mode == 'x' ? (v:prevcount == 0 ? 1 : v:prevcount) : v:count1
  let operator.mode  = a:mode
  let operator.view  = winsaveview()
  let operator.cursor.keep[0:3] = getpos('.')[0:3]

  call operator.opt.arg.update(get(a:000, 0, {}))
  let operator.recipes.arg = get(a:000, 1, [])

  if a:mode ==# 'x' && visualmode() ==# "\<C-v>"
    " The case for blockwise selections in visual mode
    " NOTE: 'is_extended' could be recorded safely only at here. Do not move.
    let reg = [getreg('"'), getregtype('"')]
    normal! gv
    let is_extended = winsaveview().curswant == 1/0
    silent normal! ""y
    let regtype = getregtype('"')
    call setreg('"', reg[0], reg[1])

    let operator.extended   = is_extended
    let operator.blockwidth = str2nr(regtype[1:])
  else
    let operator.extended   = 0
    let operator.blockwidth = 0
  endif

  let operator.basket = []

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
  " NOTE: force to set highlight=0
  let arg_opt = get(a:000, 0, {})
  let arg_recipes = get(a:000, 1, [])
  call operator#sandwich#prerequisite(a:kind, a:mode, arg_opt, arg_recipes)
  let operator = g:operator#sandwich#object
  let operator.num = 1
  let operator.opt.timeoutlen = s:get('timeoutlen', &timeoutlen)
  let operator.opt.timeoutlen = operator.opt.timeoutlen < 0 ? 0 : operator.opt.timeoutlen
  call operator.opt.default.update({'highlight': 0, 'query_once': 1})

  " build stuff
  let stuff = deepcopy(s:stuff)
  let stuff.acts  = map(range(operator.num), 'deepcopy(s:act)')

  " put stuffs as needed
  let operator.basket = map(range(operator.count), 'deepcopy(stuff)')

  " connect links
  for stuff in operator.basket
    let stuff.cursor         = operator.cursor
    let stuff.modmark        = operator.modmark
    " NOTE: stuff.opt.filter is actually does not depend on the motionwise.
    let stuff.opt            = copy(operator.opt)
    let stuff.opt.filter     = s:default_opt[a:kind]['filter']
    let stuff.opt.recipe     = deepcopy(s:opt)
    let stuff.opt.integrated = deepcopy(s:opt)
    let stuff.opt.integrate  = function('s:opt_integrate')
    call stuff.opt.integrate()
    for act in stuff.acts
      let act.cursor  = stuff.cursor
      let act.modmark = stuff.modmark
      let act.opt     = stuff.opt
    endfor
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

    if operator.count > 1 && i == 0 && operator.state && opt.integrated.query_once
      for _i in range(1, len(operator.basket) - 1)
        let _stuff = operator.basket[_i]
        call extend(_stuff.buns, stuff.buns, 'force')
        call _stuff.opt.recipe.update(stuff.opt.recipe)
        call _stuff.opt.integrated()
      endfor
      break
    endif
  endfor

  if filter(copy(operator.basket), 'has_key(v:val, "buns")') != []
    let operator.state = 0
    let &l:operatorfunc = 'operator#sandwich#' . a:kind
    let cmd = 'g@'
    if a:mode ==# 'x'
      let cmd = 'gv' . cmd
    endif
    call feedkeys(cmd, 'n')
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



""" objects
function! s:opt_clear() dict abort "{{{
  call filter(self, 'v:key =~# ''\%(clear\|update\|integrate\)''')
endfunction
"}}}
function! s:opt_update(dict) dict abort "{{{
  call self.clear()
  call extend(self, a:dict, 'keep')
endfunction
"}}}
function! s:opt_integrate() dict abort  "{{{
  call self.integrated.clear()
  let default = filter(copy(self.default), self.filter)
  let arg     = filter(copy(self.arg),     self.filter)
  let recipe  = filter(copy(self.recipe),  self.filter)
  call extend(self.integrated, default, 'force')
  call extend(self.integrated, arg,     'force')
  call extend(self.integrated, recipe,  'force')
endfunction
"}}}
" opt object  {{{
let s:opt = {'filter': ''}
let s:opt.clear  = function('s:opt_clear')
let s:opt.update = function('s:opt_update')
"}}}

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
" clock object  {{{
let s:clock = {
      \   'started' : 0,
      \   'paused'  : 0,
      \   'zerotime': reltime(),
      \   'stoptime': reltime(),
      \   'losstime': 0,
      \ }
let s:clock.start   = function('s:clock_start')
let s:clock.pause   = function('s:clock_pause')
let s:clock.elapsed = function('s:clock_elapsed')
let s:clock.stop    = function('s:clock_stop')
"}}}

function! s:add_once(buns, undojoin, done, next_act) dict abort "{{{
  let target   = self.target
  let modmark  = self.modmark
  let opt      = self.opt.integrated
  let undojoin = a:undojoin
  let done     = a:done
  let indent   = [0, 0]
  let is_linewise = [0, 0]

  let undojoin_cmd = undojoin ? 'undojoin | ' : ''

  if opt.noremap
      let startinsert_i = 'normal! i'
      let startinsert_O = 'normal! O'
      let startinsert_o = 'normal! o'
  else
      let startinsert_i = "normal \<Plug>(sandwich-i)"
      let startinsert_O = "normal \<Plug>(sandwich-O)"
      let startinsert_o = "normal \<Plug>(sandwich-o)"
  endif

  if s:is_valid_4pos(target)
        \ && s:is_equal_or_ahead(target.head2, target.head1)
    if target.head2[2] != col([target.head2[1], '$'])
      let target.head2[0:3] = s:get_right_pos(target.head2)
    endif

    call self.set_indent()
    try
      call setpos('.', target.head2)
      if s:is_in_cmdline_window
        " workaround for a bug in cmdline-window
        call s:paste(0, a:buns, undojoin_cmd)
      elseif opt.linewise
        execute undojoin_cmd . startinsert_o . a:buns[1]
        let is_linewise[1] = 1
      else
        execute undojoin_cmd . startinsert_i . a:buns[1]
      endif
      let indent[1] = indent(line("']"))
      let tail = getpos("']")

      call setpos('.', target.head1)
      if s:is_in_cmdline_window
        " workaround for a bug in cmdline-window
        call s:paste(1, a:buns)
      elseif opt.linewise
        execute startinsert_O . a:buns[0]
        let is_linewise[0] = 1
      else
        execute startinsert_i . a:buns[0]
      endif
      let indent[0] = indent(line("']"))
      let head = getpos("'[")
    catch /^Vim\%((\a\+)\)\=:E21/
      throw 'OperatorSandwichError:Add:ReadOnly'
    finally
      call self.restore_indent()
    endtry

    " get tail
    call s:push1(tail, target, a:buns, indent, is_linewise)

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

    " update cursor position
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
function! s:delete_once(done, next_act) dict abort  "{{{
  let target   = self.target
  let modmark  = self.modmark
  let opt      = self.opt.integrated
  let done     = a:done
  let is_linewise = [0, 0]
  let no_shift = 0

  if s:is_valid_4pos(target)
        \ && s:is_ahead(target.head2, target.tail1)
    if target.tail1 == s:get_left_pos(target.head2)
      " a trick for the case nothing inside, like '()'
      let no_shift = 1
    endif

    let deletion = ['', '']
    let reg = [getreg('"'), getregtype('"')]
    let cmd = "silent normal! \"\"dv:call setpos('\.', %s)\<CR>"
    try
      call setpos('.', target.head2)
      let @@ = ''
      execute printf(cmd, 'target.tail2')
      let deletion[1] = @@
      if opt.linewise == 2
            \ || (opt.linewise && match(getline('.'), '^\s*$') > -1)
        if getpos('.')[1] != target.head1[1]
          .delete
          let is_linewise[1] = 1
        else
          let no_shift = 1
        endif
      endif

      call setpos('.', target.head1)
      let @@ = ''
      execute printf(cmd, 'target.tail1')
      let deletion[0] = @@
      if opt.linewise == 2 ||
            \ (opt.linewise && match(getline('.'), '^\s*$') > -1)
        .delete
        let head = getpos("']")
        let is_linewise[0] = 1
      else
        let head = getpos('.')
      endif
    catch /^Vim\%((\a\+)\)\=:E21/
      throw 'OperatorSandwichError:Delete:ReadOnly'
    finally
      call setreg('"', reg[0], reg[1])
    endtry

    " get tail
    let tail = s:shift_for_delete(copy(target.tail2), target, deletion, is_linewise)

    " update modmark
    if modmark.head == s:null_pos || s:is_ahead(modmark.head, head)
      let modmark.head = head
    endif
    " NOTE: Probably, there is no possibility to delete breakings along multiple acts.
    if !done
      let _tail = no_shift || tail[2] == col([tail[1], '$'])
            \ ? tail : s:get_right_pos(tail)
      if modmark.tail == s:null_pos
        let modmark.tail = _tail
      else
        call s:shift_for_delete(modmark.tail, target, deletion, is_linewise)
        if _tail[1] >= modmark.tail[1]
          let modmark.tail = _tail
        endif
      endif
    endif

    " update cursor position
    call s:shift_for_delete(self.cursor.inner_head, target, deletion, is_linewise)
    call s:shift_for_delete(self.cursor.keep,       target, deletion, is_linewise)
    call s:shift_for_delete(self.cursor.inner_tail, target, deletion, is_linewise)

    " update next_act
    let a:next_act.region.head = copy(head)
    let a:next_act.region.tail = copy(tail)

    let done = 1
  endif
  return done
endfunction
"}}}
function! s:replace_once(buns, undojoin, done, next_act) dict abort "{{{
  let target   = self.target
  let modmark  = self.modmark
  let opt      = self.opt.integrated
  let undojoin = a:undojoin
  let done     = a:done
  let is_linewise = [0, 0]
  let indent   = [0, 0]

  if s:is_valid_4pos(target)
        \ && s:is_ahead(target.head2, target.tail1)
    let undojoin_cmd = a:undojoin ? 'undojoin | ' : ''

    if opt.noremap
      let startinsert_i = 'normal! i'
      let startinsert_O = 'normal! O'
      let startinsert_o = 'normal! o'
    else
      let startinsert_i = "normal \<Plug>(sandwich-i)"
      let startinsert_O = "normal \<Plug>(sandwich-O)"
      let startinsert_o = "normal \<Plug>(sandwich-o)"
    endif

    set virtualedit=
    let next_head = s:get_right_pos(target.tail1)
    let next_tail = s:get_left_pos(target.head2)
    set virtualedit=onemore

    let deletion = ['', '']
    let reg = [getreg('"'), getregtype('"')]
    let cmd = "silent normal! \"\"dv:call setpos('\.', %s)\<CR>"
    call self.set_indent()
    try
      call setpos('.', target.head2)
      let @@ = ''
      execute undojoin_cmd . printf(cmd, 'target.tail2')
      let deletion[1] = @@
      if s:is_in_cmdline_window
        " workaround for a bug in cmdline-window
        call s:paste(0, a:buns)
      elseif opt.linewise == 2 ||
            \ (opt.linewise && match(getline('.'), '^\s*$') > -1)
        if getpos('.')[1] != target.head1[1]
          .delete
          normal! k
          execute startinsert_o . a:buns[1]
          let indent[1] = indent(line("']"))
          let is_linewise[1] = 1
        endif
      else
        execute startinsert_i . a:buns[1]
      endif
      let tail = getpos("']")

      call setpos('.', target.head1)
      let @@ = ''
      execute printf(cmd, 'target.tail1')
      let deletion[0] = @@
      if s:is_in_cmdline_window
        " workaround for a bug in cmdline-window
        call s:paste(1, a:buns)
      elseif opt.linewise == 2 ||
            \ (opt.linewise && match(getline('.'), '^\s*$') > -1)
        .delete
        execute startinsert_O . a:buns[0]
        let indent[0] = indent(line("']"))
        let is_linewise[0] = 1
      else
        execute startinsert_i . a:buns[0]
      endif
      let head = getpos("'[")
    catch /^Vim\%((\a\+)\)\=:E21/
      throw 'OperatorSandwichError:Replace:ReadOnly'
    finally
      call setreg('"', reg[0], reg[1])
      call self.restore_indent()
    endtry

    " update tail
    call s:pull1(tail, target, deletion, is_linewise)
    call s:push1(tail, target, a:buns, indent, is_linewise)

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

    " update cursor position
    call s:shift_for_replace(self.cursor.keep, target, a:buns, deletion, indent, is_linewise)
    call s:shift_for_replace(next_head, target, a:buns, deletion, indent, is_linewise)
    call s:shift_for_replace(next_tail, target, a:buns, deletion, indent, is_linewise)
    if self.cursor.inner_head == s:null_pos
          \ || target.head1[1] <= self.cursor.inner_head[1]
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
function! s:search(recipes) dict abort "{{{
  let recipes = deepcopy(a:recipes)
  let filter  = 's:has_action(v:val, "delete")'
  call filter(recipes, filter)
  let region  = self.region
  let opt     = self.opt
  let target  = copy(s:null_4pos)

  if s:is_valid_2pos(region) && s:is_ahead(region.tail, region.head)
    let head = deepcopy(region.head)
    let tail = deepcopy(region.tail)

    for i in [1, 2]
      " check the recipe
      let found = 0
      for candidate in recipes
        call opt.recipe.update(candidate)
        call opt.integrate()
        if i == 1 || opt.integrated.skip_space
          if has_key(candidate, 'buns')
            " search buns
            let target = s:check_edges(head, tail, candidate, opt.integrated)
          elseif has_key(candidate, 'external')
            " get difference of external motion/textobject
            let target = s:get_external_diff_region(head, tail, candidate, opt.integrated)
          else
            let target = deepcopy(s:null_4pos)
          endif
          if s:is_valid_4pos(target)
            let found = 1
            break
          endif
        endif
      endfor
      if found | break | endif

      " check the case that same characters are at both ends
      call opt.recipe.clear()
      call opt.integrate()
      if i == 1 || opt.integrated.skip_space
        let head_c = s:get_cursorchar(head)
        let tail_c = s:get_cursorchar(tail)
        if head_c ==# tail_c && !(opt.integrated.skip_space == 2 && head_c =~# '\s')
          let target = {
                \   'head1': head, 'tail1': head,
                \   'head2': tail, 'tail2': tail,
                \ }
          break
        endif
      endif

      if i == 1
        " skip space
        if head_c =~# '\s' || tail_c =~# '\s'
          if head_c =~# '\s'
            call s:skip_space(head, '', tail[1])
            if head == s:null_pos || s:is_equal_or_ahead(head, tail)
              break
            endif
          endif
          if tail_c =~# '\s'
            call s:skip_space(tail, 'b', head[1])
            if tail == s:null_pos || s:is_equal_or_ahead(head, tail)
              break
            endif
          endif
        else
          break
        endif
      endif
    endfor

    " skip characters
    if target == s:null_4pos
      let target_list = []
      for candidate in recipes
        call opt.recipe.update(candidate)
        call opt.integrate()
        if opt.integrated.skip_char && has_key(candidate, 'buns')
          let head = region.head
          let tail = region.tail
          let target_list += [s:search_edges(head, tail, candidate, opt.integrated)]
        endif
      endfor
      call filter(target_list, 's:is_valid_4pos(v:val)')
      if target_list != []
        let target = s:shortest(target_list)
      endif
    endif
  endif

  let self.target = target
endfunction
"}}}
function! s:set_indent() dict abort "{{{
  let opt    = self.opt.integrated
  let indent = self.indent

  call extend(indent, {
        \   'restore_indent': 0,
        \   'autoindent': [&l:autoindent, &l:smartindent, &l:cindent, &l:indentexpr],
        \   'restore_indentkeys': 0,
        \   'indentkeys': '',
        \ }, 'force')

  " set autoindent options
  if opt.autoindent == 0
    let [&l:autoindent, &l:smartindent, &l:cindent, &l:indentexpr] = [0, 0, 0, '']
    let indent.restore_indent = 1
  elseif opt.autoindent == 1
    let [&l:autoindent, &l:smartindent, &l:cindent, &l:indentexpr] = [1, 0, 0, '']
    let indent.restore_indent = 1
  elseif opt.autoindent == 2
    " NOTE: 'Smartindent' requires 'autoindent'. :help 'smartindent'
    let [&l:autoindent, &l:smartindent, &l:cindent, &l:indentexpr] = [1, 1, 0, '']
    let indent.restore_indent = 1
  elseif opt.autoindent == 3
    let [&l:cindent, &l:indentexpr] = [1, '']
    let indent.restore_indent = 1
  endif

  " set indentkeys
  if &l:indentexpr !=# ''
    let indent.indentkeys = &l:indentkeys
    call self.set_indentkeys('indentkeys')
  elseif &l:cindent
    let indent.indentkeys = &l:cinkeys
    call self.set_indentkeys('cinkeys')
  endif
endfunction
"}}}
function! s:restore_indent() dict abort  "{{{
  let opt    = self.opt.integrated
  let indent = self.indent

  " restore indentkeys first
  if indent.restore_indentkeys
    if &l:indentexpr !=# ''
      let &l:indentkeys = indent.indentkeys
    elseif &l:cindent
      let &l:cinkeys = indent.indentkeys
    endif
  endif

  " restore autoindent options
  if indent.restore_indent
    if opt.autoindent == 0
      let [&l:autoindent, &l:smartindent, &l:cindent, &l:indentexpr] = indent.autoindent
    elseif opt.autoindent == 1
      let [&l:autoindent, &l:smartindent, &l:cindent, &l:indentexpr] = indent.autoindent
    elseif opt.autoindent == 2
      let [&l:autoindent, &l:smartindent, &l:cindent, &l:indentexpr] = indent.autoindent
    elseif opt.autoindent == 3
      let [&l:cindent, &l:indentexpr] = indent.autoindent[2:]
    endif
  endif
endfunction
"}}}
function! s:set_indentkeys(indentkeys) dict abort  "{{{
  let opt    = self.opt.integrated
  let indent = self.indent

  if opt['indentkeys'] !=# ''
    execute 'setlocal ' . a:indentkeys . '=' . opt['indentkeys']
    let indent.restore_indentkeys = 1
  endif

  if opt['indentkeys+'] !=# ''
    execute 'setlocal ' . a:indentkeys . '+=' . opt['indentkeys+']
    let indent.restore_indentkeys = 1
  endif

  if opt['indentkeys-'] !=# ''
    " It looks there is no way to add ',' itself to 'indentkeys'
    for item in split(opt['indentkeys-'], ',')
      execute 'setlocal ' . a:indentkeys . '-=' . item
    endfor
    let indent.restore_indentkeys = 1
  endif
endfunction
"}}}
" act object  {{{
let s:act = {
      \   'region' : copy(s:null_2pos),
      \   'target' : copy(s:null_4pos),
      \   'cursor' : {},
      \   'modmark': {},
      \   'indent' : {},
      \ }
let s:act.add_once     = function('s:add_once')
let s:act.delete_once  = function('s:delete_once')
let s:act.replace_once = function('s:replace_once')
let s:act.search       = function('s:search')
let s:act.set_indent   = function('s:set_indent')
let s:act.restore_indent = function('s:restore_indent')
let s:act.set_indentkeys = function('s:set_indentkeys')
"}}}

function! s:query(recipes) dict abort  "{{{
  let filter = 'has_key(v:val, "buns")
          \ && (!has_key(v:val, "regex") || !v:val.regex)
          \ && s:has_action(v:val, "add")'
  let recipes = filter(deepcopy(a:recipes), filter)
  let opt   = self.opt.integrated
  let clock = self.clock
  let acts  = self.acts
  let timeoutlen = self.opt.timeoutlen

  let id_list = []
  if opt.highlight
    let id_list = s:highlight_add(acts)
  endif
  redraw

  try
    " query phase
    let input   = ''
    let cmdline = []
    let last_compl_match = ['', []]
    while 1
      let c = getchar(0)
      if c == 0
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
      call self.opt.recipe.update(recipe)
      call self.opt.integrate()
    endif
  finally
    " delete highlight
    if filter(id_list, 'v:val > 0') != []
      call map(id_list, 's:highlight_del(v:val)')
    endif

    call clock.stop()
  endtry
endfunction
"}}}
function! s:show() dict abort "{{{
  let clock = self.clock
  let acts  = self.acts
  let hi_exited = 0

  try
    let id_list = s:highlight_add(acts)
    redraw

    let c = 0
    call clock.start()
    while c == 0
      let c = getchar(0)
      if clock.started && clock.elapsed() > self.opt.duration
        break
      endif
      sleep 20m
    endwhile

    if c != 0
      let c = type(c) == s:type_num ? nr2char(c) : c
      call feedkeys(c, 't')
      let hi_exited = 1
    endif
  finally
    " delete highlight
    if filter(id_list, 'v:val > 0') != []
      call map(id_list, 's:highlight_del(v:val)')
    endif

    call clock.stop()
    return hi_exited
  endtry
endfunction
"}}}
function! s:command() dict abort  "{{{
  let modmark = self.modmark
  let head = getpos("'[")
  let tail = getpos("']")
  call setpos("'[", modmark.head)
  call setpos("']", modmark.tail)
  for cmd in self.opt.integrated.command
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
function! s:get_buns() dict abort  "{{{
  let opt = self.opt.integrated
  let buns = self.buns

  if (opt.expr && !self.evaluated) || opt.expr == 2
    echo ''
    let buns = opt.expr == 2 ? deepcopy(buns) : buns
    let buns[0] = s:eval(buns[0], 1)
    let buns[1] = s:eval(buns[1], 0)
    let self.evaluated = 1
    redraw
    echo ''
  endif

  return buns
endfunction
"}}}
" stuff object {{{
let s:stuff = {
      \   'buns'   : [],
      \   'num'    : 1,
      \   'done'   : 0,
      \   'cursor' : {},
      \   'modmark': {},
      \   'opt'    : {},
      \   'clock'  : copy(s:clock),
      \   'acts'   : [],
      \   'evaluated': 0,
      \ }
let s:stuff.query    = function('s:query')
let s:stuff.show     = function('s:show')
let s:stuff.command  = function('s:command')
let s:stuff.get_buns = function('s:get_buns')
"}}}

function! s:execute(kind, motionwise) dict abort  "{{{
  " FIXME: What is the best practice to handle exceptions?
  "        Serious lack of the experience with error handlings...
  let errormsg = ''
  let [virtualedit, whichwrap]   = [&virtualedit, &whichwrap]
  let [&virtualedit, &whichwrap] = ['onemore', 'h,l']
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

    " restore options
    call self.finalize()
    let [&virtualedit, &whichwrap] = [virtualedit, whichwrap]
  endtry
endfunction
"}}}
function! s:initialize(kind, motionwise) dict abort "{{{
  let region = s:get_assigned_region(a:kind, a:motionwise)
  let region_list = a:motionwise ==# 'block' ? self.split(region) : [region]

  if region == s:null_2pos
    " deactivate
    let self.state = -1
  else
    " hide_cursor
    if s:has_gui_running
      let self.cursor_info = &guicursor
      set guicursor+=o:block-NONE
    else
      let self.cursor_info = &t_ve
      set t_ve=
    endif
  endif

  let self.num = len(region_list)
  let self.opt.timeoutlen = s:get('timeoutlen', &timeoutlen)
  let self.opt.timeoutlen = self.opt.timeoutlen < 0 ? 0 : self.opt.timeoutlen
  let self.opt.duration = s:get('highlight_duration', 200)
  let self.opt.duration = self.opt.duration < 0 ? 0 : self.opt.duration
  let self.opt.filter = s:default_opt[a:kind]['filter']
  let self.opt.integrate  = function('s:opt_integrate')
  let self.cursor.inner_head = region.head
  let self.cursor.inner_tail = region.tail
  call self.opt.default.update(deepcopy(g:operator#sandwich#options[a:kind][a:motionwise]))

  if self.state
    " build stuff
    let stuff = deepcopy(s:stuff)
    let stuff.acts = map(range(self.num), 'deepcopy(s:act)')

    " put stuffs as needed
    let self.basket = map(range(self.count), 'deepcopy(stuff)')

    " connect links
    for stuff in self.basket
      let stuff.cursor         = self.cursor
      let stuff.modmark        = self.modmark
      let stuff.opt            = copy(self.opt)
      let stuff.opt.recipe     = deepcopy(s:opt)
      let stuff.opt.integrated = deepcopy(s:opt)
      call stuff.opt.integrate()
      for act in stuff.acts
        let act.cursor  = stuff.cursor
        let act.modmark = stuff.modmark
        let act.opt     = stuff.opt
      endfor
    endfor
  else
    let self.view = winsaveview()
    let self.modmark.head = copy(s:null_pos)
    let self.modmark.tail = copy(s:null_pos)

    for stuff in self.basket
      let stuff.done = 0
      call stuff.opt.integrate()

      let lack = self.num - len(stuff.acts)
      if lack > 0
        let fillings = map(range(lack), 'deepcopy(s:act)')
        for act in fillings
          let act.cursor  = stuff.cursor
          let act.modmark = stuff.modmark
          let act.opt     = stuff.opt
        endfor
        let stuff.acts += fillings
      endif
      call map(stuff.acts, 'extend(v:val, {"state": 0}, "force")')
    endfor
  endif

  " set initial values
  let stuff = self.basket[0]
  for j in range(self.num)
    let act = stuff.acts[j]
    let act.region = region_list[j]
  endfor
endfunction
"}}}
function! s:split(region) dict abort  "{{{
  let reg  = [getreg('"'), getregtype('"')]
  let view = winsaveview()
  let virtualedit = &virtualedit
  let &virtualedit = 'all'
  try
    if self.blockwidth == 0
      " The case for blockwise motions in operator-pending mode
      execute "normal! `[\<C-v>`]"
      silent normal! ""y
      execute "normal! \<Esc>"
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
        else
          let region_list += [deepcopy(s:null_2pos)]
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
        else
          let region_list += [deepcopy(s:null_2pos)]
        endif
      endfor
    endif
  finally
    call setreg('"', reg[0], reg[1])
    call winrestview(view)
    let &virtualedit = virtualedit
  endtry
  return region_list
endfunction
"}}}
function! s:add() dict abort "{{{
  let undojoin = 0
  for i in range(self.count)
    let stuff = self.basket[i]
    let next_stuff = get(self.basket, i + 1, deepcopy(stuff))
    let opt = stuff.opt.integrated

    for j in range(self.num)
      let act = stuff.acts[j]
      let act.target.head1 = copy(act.region.head)
      let act.target.tail1 = act.target.head1
      let act.target.head2 = copy(act.region.tail)
      let act.target.tail2 = act.target.head2

      if opt.skip_space
        call s:skip_space(act.target.head1, 'c',  act.target.head2[1])
        call s:skip_space(act.target.head2, 'bc', act.target.tail1[1])
      endif
    endfor

    if self.state
      " query preferable buns
      call winrestview(self.view)
      call stuff.query(self.recipes.integrated)
    endif
    if stuff.buns == [] || len(stuff.buns) < 2
      break
    endif

    if self.count > 1 && i == 0 && self.state && opt.query_once
      for _i in range(1, len(self.basket) - 1)
        let _stuff = self.basket[_i]
        call extend(_stuff.buns, stuff.buns, 'force')
        call _stuff.opt.recipe.update(stuff.opt.recipe)
        call _stuff.opt.integrate()
      endfor
      let self.state = 0
    endif

    let buns = stuff.get_buns()
    for j in range(self.num)
      let act      = stuff.acts[j]
      let next_act = next_stuff.acts[j]
      let [undojoin, stuff.done]
            \ = act.add_once(buns, undojoin, stuff.done, next_act)
    endfor
    let self.cursor.head = copy(self.modmark.head)
    let self.cursor.tail = s:get_left_pos(self.modmark.tail)
    let undojoin = self.state ? 1 : 0

    if stuff.done && opt.command != []
      call stuff.command()
    endif

  endfor
endfunction
"}}}
function! s:delete() dict abort  "{{{
  let hi_exited = 0

  for i in range(self.count)
    let stuff = self.basket[i]
    let next_stuff = get(self.basket, i + 1, deepcopy(stuff))

    for j in range(self.num)
      let act = stuff.acts[j]
      call act.search(self.recipes.integrated)
    endfor
    if filter(copy(stuff.acts), 's:is_valid_4pos(v:val.target)') == []
      break
    endif

    if !hi_exited && stuff.opt.integrated.highlight && self.opt.duration> 0
      call winrestview(self.view)
      let hi_exited = stuff.show()
    endif

    for j in range(self.num)
      let act      = stuff.acts[j]
      let next_act = next_stuff.acts[j]
      let stuff.done = act.delete_once(stuff.done, next_act)
    endfor
    let self.cursor.head = copy(self.modmark.head)
    let self.cursor.tail = s:get_left_pos(self.modmark.tail)

    if stuff.done && stuff.opt.integrated.command != []
      call stuff.command()
    endif
  endfor
endfunction
"}}}
function! s:replace() dict abort  "{{{
  let self.cursor.inner_head = copy(s:null_pos)
  let self.cursor.inner_tail = copy(s:null_pos)

  let undojoin = 0
  for i in range(self.count)
    let stuff = self.basket[i]
    let next_stuff = get(self.basket, i + 1, deepcopy(stuff))
    let opt = stuff.opt.integrated

    for j in range(self.num)
      let act = stuff.acts[j]
      call act.search(self.recipes.integrated)
    endfor
    if filter(copy(stuff.acts), 's:is_valid_4pos(v:val.target)') == []
      break
    endif

    if self.state
      " query preferable buns
      call winrestview(self.view)
      call stuff.query(self.recipes.integrated)
    endif
    if stuff.buns == [] || len(stuff.buns) < 2
      break
    endif

    if self.count > 1 && i == 0 && self.state && opt.query_once
      for _i in range(1, len(self.basket) - 1)
        let _stuff = self.basket[_i]
        call extend(_stuff.buns, stuff.buns, 'force')
        call _stuff.opt.recipe.update(stuff.opt.recipe)
        call _stuff.opt.integrate()
      endfor
      let self.state = 0
    endif

    let buns = stuff.get_buns()
    for j in range(self.num)
      let act      = stuff.acts[j]
      let next_act = next_stuff.acts[j]
      let [undojoin, stuff.done]
            \ = act.replace_once(buns, undojoin, stuff.done, next_act)
    endfor
    let self.cursor.head = copy(self.modmark.head)
    let self.cursor.tail = s:get_left_pos(self.modmark.tail)
    let undojoin = self.state ? 1 : 0

    if stuff.done && opt.command != []
      call stuff.command()
    endif
  endfor
endfunction
"}}}
function! s:finalize() dict abort  "{{{
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
          let cursor_opt = stuff.opt.integrated.cursor
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

    " restore cursor
    if has_key(self, 'cursor_info')
      if s:has_gui_running
        set guicursor&
        let &guicursor = self.cursor_info
      else
        let &t_ve = self.cursor_info
      endif
    endif
  endif

  " set state
  let self.state = 0
endfunction
"}}}
function! s:recipe_integrate(kind, motionwise, mode) dict abort  "{{{
  let self.integrated = []
  if self.arg != []
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
" operator object {{{
let s:operator = {
      \   'state'     : 0,
      \   'count'     : 1,
      \   'num'       : 1,
      \   'mode'      : 'n',
      \   'view'      : {},
      \   'blockwidth': 0,
      \   'extended'  : 0,
      \   'keepable'  : 0,
      \   'recipes'   : {
      \     'arg'       : [],
      \     'synchro'   : [],
      \     'integrated': [],
      \   },
      \   'cursor': {
      \     'head'      : copy(s:null_pos),
      \     'inner_head': copy(s:null_pos),
      \     'keep'      : copy(s:null_pos),
      \     'inner_tail': copy(s:null_pos),
      \     'tail'      : copy(s:null_pos),
      \   },
      \   'modmark': copy(s:null_2pos),
      \   'opt': {
      \     'arg'    : copy(s:opt),
      \     'default': copy(s:opt),
      \   },
      \   'basket'    : [],
      \ }
let s:operator.execute    = function('s:execute')
let s:operator.initialize = function('s:initialize')
let s:operator.split      = function('s:split')
let s:operator.add        = function('s:add')
let s:operator.delete     = function('s:delete')
let s:operator.replace    = function('s:replace')
let s:operator.finalize   = function('s:finalize')
let s:operator.recipes.integrate = function('s:recipe_integrate')
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
function! s:check_edges(head, tail, candidate, opt) abort  "{{{
  let patterns = s:get_patterns(a:candidate, a:opt)

  if patterns[0] ==# '' || patterns[1] ==# '' | return s:null_4pos | endif

  call setpos('.', a:head)
  let head1 = searchpos(patterns[0], 'c', a:tail[1])

  if head1 != a:head[1:2] | return s:null_4pos | endif

  call setpos('.', a:tail)
  let tail2 = s:searchpos_bce(a:tail, patterns[1], a:head[1])

  if tail2 != a:tail[1:2] | return s:null_4pos | endif

  let head2 = searchpos(patterns[1], 'bc', a:head[1])
  call setpos('.', a:head)
  let tail1 = searchpos(patterns[0], 'ce', a:tail[1])

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
function! s:search_edges(head, tail, candidate, opt) abort "{{{
  let patterns = s:get_patterns(a:candidate, a:opt)

  if patterns[0] ==# '' || patterns[1] ==# '' | return s:null_4pos | endif

  call setpos('.', a:head)
  let head1 = searchpos(patterns[0], 'c', a:tail[1])

  call setpos('.', a:tail)
  let tail2 = s:searchpos_bce(a:tail, patterns[1], a:head[1])

  if head1 == s:null_coord || tail2 == s:null_coord
        \ || s:is_equal_or_ahead(s:c2p(head1), s:c2p(tail2))
    return s:null_4pos
  endif

  let head2 = searchpos(patterns[1], 'bc', head1[0])
  call setpos('.', s:c2p(head1))
  let tail1 = searchpos(patterns[0], 'ce', head2[0])

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
function! s:get_patterns(candidate, opt) abort "{{{
  if has_key(a:opt, 'expr') && a:opt.expr
    return ['', '']
  endif

  let patterns = deepcopy(a:candidate.buns)
  if !a:opt.regex
    let patterns = map(patterns, 's:escape(v:val)')
  endif

  " substitute a break "\n" to a regular expression pattern '\n'
  let patterns = map(patterns, 'substitute(v:val, ''\n'', ''\\n'', ''g'')')
  return patterns
endfunction
"}}}
function! s:skip_space(pos, flag, stopline) abort  "{{{
  call setpos('.', a:pos)
  if a:pos[2] == col([a:pos[1], '$'])
    " if the cursor is on a line breaking, it should not be skipped.
    let dest = a:pos
  else
    let dest = s:c2p(searchpos('\_S', a:flag, a:stopline))
  endif
  let validity = 0
  if dest != s:null_pos
    if stridx(a:flag, 'b') > -1
      if stridx(a:flag, 'c') > -1
        let validity = s:is_equal_or_ahead(a:pos, dest)
      else
        let validity = s:is_ahead(a:pos, dest)
      endif
    else
      if stridx(a:flag, 'c') > -1
        let validity = s:is_equal_or_ahead(dest, a:pos)
      else
        let validity = s:is_ahead(dest, a:pos)
      endif
    endif
  endif

  if validity
    let a:pos[0:3] = dest[0:3]
  else
    let a:pos[0:3] = copy(s:null_pos)[0:3]
  endif
endfunction
"}}}
function! s:get_external_diff_region(head, tail, candidate, opt) abort  "{{{
  let target = deepcopy(s:null_4pos)
  let [textobj_i, textobj_a] = a:candidate.external
  let cmd = a:opt.noremap ? 'normal!' : 'normal'
  let v   = a:opt.noremap ? 'v' : "\<Plug>(sandwich-v)"
  let [visual_head, visual_tail] = [getpos("'<"), getpos("'>")]
  let visualmode = visualmode()

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

  " restore operatorfunc
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
    call s:push(shift, a:shifted_pos, head, a:addition[0], a:indent[0], a:is_linewise[0])
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
    call s:push(shift, a:shifted_pos, head, a:addition[1], a:indent[1], a:is_linewise[1])
    let a:shifted_pos[1:2] += shift[1:2]
  endif
  return a:shifted_pos
endfunction
"}}}
function! s:push(shift, shifted_pos, head, addition, indent, is_linewise) abort  "{{{
  if s:is_equal_or_ahead(a:shifted_pos, a:head)
    let addition = split(a:addition, '\n', 1)

    " lnum
    let a:shift[1] += len(addition) - 1
    " column
    if !a:is_linewise
          \ && a:head[1] == a:shifted_pos[1]
      let a:shift[2] += strlen(addition[-1])
      if len(addition) > 1
        let a:shift[2] -= a:head[2] - 1
        let a:shift[2] += a:indent - strlen(matchstr(addition[-1], '^\s*'))
      endif
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

" highlight
function! s:highlight_add(acts) abort  "{{{
  let order_list = []
  for act in a:acts
    let target = act.target
    if s:is_valid_4pos(target)
      call s:highlight_order(order_list, target.head1, target.tail1)
      call s:highlight_order(order_list, target.head2, target.tail2)
    endif
  endfor

  let id_list    = []
  if order_list != []
    for order in order_list
      let id_list += s:matchaddpos('OperatorSandwichBuns', order)
    endfor
  endif
  return id_list
endfunction
"}}}
function! s:highlight_del(id) abort "{{{
  return matchdelete(a:id)
endfunction
"}}}
function! s:highlight_order(order_list, head, tail) abort "{{{
  if a:head != s:null_pos && a:tail != s:null_pos && s:is_equal_or_ahead(a:tail, a:head)
    let n     = 0
    let order = []

    for lnum in range(a:head[1], a:tail[1])
      if a:head[1] == a:tail[1]
        let order += [a:head[1:2] + [a:tail[2] - a:head[2] + 1]]
      else
        if lnum == a:head[1]
          let order += [a:head[1:2] + [col([lnum, '$']) - a:head[2] + 1]]
        elseif lnum == a:tail[1]
          let order += [[lnum, 1] + [a:tail[2]]]
        else
          let order += [[lnum]]
        endif
      endif

      if n == 7
        call add(a:order_list, order)
        let order = []
        let n = 0
      else
        let n += 1
      endif
    endfor

    if order != []
      call add(a:order_list, order)
    endif
  endif
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

" miscellaneous
function! s:get_cursorchar(pos) abort "{{{
  let reg = [getreg('"'), getregtype('"')]
  call setpos('.', a:pos)
  normal! yl
  let c = @@
  call setreg('"', reg[0], reg[1])
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
function! s:is_input_matched(candidate, input, opt, flag) abort "{{{
  if !has_key(a:candidate, 'buns')
    return 0
  elseif !a:flag && a:input ==# ''
    return 1
  endif

  let candidate = deepcopy(a:candidate)
  call a:opt.recipe.update(candidate)
  call a:opt.integrate()

  " 'input' is necessary for 'expr' buns
  if a:opt.integrated.expr && !has_key(candidate, 'input')
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
function! s:paste(is_head, buns, ...) abort "{{{
  let undojoin_cmd = a:0 > 0 ? a:1 : ''
  let reg = ['"', getreg('"'), getregtype('"')]
  let @@ = a:is_head ? a:buns[0] : a:buns[1]
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
      \   'autoindent' : 1,
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
      \   'autoindent' : 1,
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
      \   'autoindent' : 1,
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
      \   'autoindent' : 1,
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
      \   'autoindent' : 1,
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
      \   'autoindent' : 1,
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
