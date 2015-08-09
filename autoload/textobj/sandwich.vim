" textobj-sandwich: pick up a sandwich!
" NOTE: Because of the restriction of vim, if a operator to get the assigned
"       region is employed for 'external' user-defined textobjects, it makes
"       impossible to repeat by dot command. Thus, 'external' is checked by
"       using visual selection (xmap) in any case.
" TODO: add a 'skip_expr' option, like {skip} argument for searchpair()

""" NOTE: Whole design (-: string or number, *: functions, []: list, {}: dictionary) "{{{
" textobj object
"   - state                 : 0 or 1. If it is called by keymapping, it is 1. If it is called by dot command, it is 0.
"   - kind                  : 'auto' or 'query'.
"   - a_or_i                : 'a' or 'i'. It means 'a sandwich' or 'inner sandwich'. See :help text-objects.
"   - mode                  : 'o' or 'x'. Which mode the keymapping is called.
"   - count                 : Positive integer. The assigned {count}
"   []cursor                : [Linked from stuff.cursor] The original position of the cursor
"   {}view                  : The dictionary to restore the view when it starts.
"   - done                  : If the textobject could find the target and select, then 1. Otherwise 0.
"   - visualmode            : If the textobject is called in blockwise visual mode, then '<C-v>'. Otherwise 'v'.
"   []recipes
"     []arg                 : The recipes which is used mandatory if it is not empty. It could be given through the 4th argument.
"     []integrated          : The recipes which are the integrated result of all recipes. This is the one used practically.
"     * integrate           : The function to set operator.recipes.integrated.
"   {}opt
"     {}arg                 : [Linked from stuff.opt.arg] The options given through the 3rd argument of textobj#sandwich#auto(). This has the highest priority to use.
"       * clear             : The function to clear the containts.
"       * update            : The function to update the containts.
"     {}default             : [Linked from stuff.opt.default] The default options
"       * clear             : The function to clear the containts.
"       * update            : The function to update the containts.
"   {}clock                 : The object to measure the time.
"     - started             : If the stopwatch has started, then 1. Otherwise 0.
"     - paused              : If the stopwatch has paused, then 1. Otherwise 0.
"     - losstime            : The erapsed time in paused periods.
"     []zerotime            : The time to start the measurement.
"     []pause_at            : The time to start temporal pause.
"     * start               : The function to start the stopwatch.
"     * pause               : The function to pause the stopwatch.
"     * erapsed             : The function to check the erapsed time from zerotime substituting losstime.
"     * stop                : The function to stop the measurement.
"   []basket                : The list holding information and histories for the action.
"     {}stuff
"       []buns              : [Linked from act.buns] The list consisted of two strings to add to/replace the edges.
"       - state             : 0 or 1. If it is called by keymapping, it is 1. If it is called by dot command, it is 0.
"       - a_or_i            : 'a' or 'i'. It means 'a sandwich' or 'inner sandwich'. See :help text-objects.
"       - mode              : 'o' or 'x' or 'n'. Which mode the keymapping is called.
"       - visualmode        : If the textobject is called in blockwise visual mode, then '<C-v>'. Otherwise 'v'.
"       - syntax            : The place to put the name of displayed syntax for skipping in search.
"       - evaluated         : If the buns are evaluated by opt.integrated.expr feature, then 1.
"       []cursor            : Linked to textobj.cursor.
"       {}clock             : Linked to textobj.clock.
"       {}coord
"         []head            : The head position of selection for 'a' case.
"         []inner_head      : The head position of selection for 'i' case.
"         []inner_tail      : The tail position of selection for 'i' case.
"         []tail            : The tail position of selection for 'a' case.
"         * next            : The function to increment the head position for the next searching loop.
"         * get_inner       : The function to get 'inner_head' and 'inner_tail'.
"       {}range             : The lines to limit the searching range. It is increased step by step.
"         - valid           : If 1, continue to search. If 0, stop searching.
"         - top             : The upper stop line.
"         - bottom          : The lower stop line.
"         - toplim          : The limit of upper stop line.
"         - botlim          : The limit of lower stop line.
"         - stride          : A stride to expand 'top' and 'bottom'.
"         - count           : The count which is used for 'external' option.
"         * next            : The function to get next 'top' and 'bottom'.
"       {}opt               : [Linked from act.opt]
"         - filter          : A strings for integrate() function to filter out redundant options.
"         {}default         : Linked to textobj.opt.default.
"         {}arg             : Linked to textobj.opt.arg.
"         {}recipe          : The copy of a snippet of recipe. But 'buns' is removed.
"           * clear         : The function to clear the containts.
"           * update        : The function to update the containts.
"         {}integrated      : The integrated options which is used in practical use.
"           * clear         : The function to clear the containts.
"           * update        : The function to update the containts.
"         * integrate       : The function that integrates three options (arg, recipe, default) to get 'integrated'.
"     * search_with_nest    : The function to search the candidate in the range with nesting structure.
"     * search_without_nest : The function to search the candidate in the range without nesting structure.
"     * searchpos           : The wrap function of searchpos() for search_without_nest.
"     * skip                : The function to judge whether skip the candidate or not in search.
"     * get_buns            : The function to return the buns which are actually used.
"   []candidates            : The copies of candidate stuff.
"   * query                 : The function to ask user to input.
"   * start                 : The function to start operation.
"   * initialize            : The function to initialize.
"   * select                : The function to search and select the target.
"   * finalize              : The function to set modified marks after all operations.
"}}}

" variables "{{{
" null valiables
let s:null_coord  = [0, 0]
let s:null_2coord = {
      \   'head': copy(s:null_coord),
      \   'tail': copy(s:null_coord),
      \ }
let s:null_4coord = {
      \   'head': copy(s:null_coord),
      \   'tail': copy(s:null_coord),
      \   'inner_head': copy(s:null_coord),
      \   'inner_tail': copy(s:null_coord),
      \ }

" types
let s:type_num  = type(0)
let s:type_str  = type('')
let s:type_list = type([])

" patchs
if v:version > 704 || (v:version == 704 && has('patch237'))
  let s:has_patch_7_4_358 = has('patch-7.4.358')
else
  let s:has_patch_7_4_358 = v:version == 704 && has('patch358')
endif

" features
let s:has_reltime_and_float = has('reltime') && has('float')
"}}}

""" Public funcs
function! textobj#sandwich#auto(mode, a_or_i, ...) abort  "{{{
  " make new textobj object
  if !exists('g:textobj#sandwich#object')
    let g:textobj#sandwich#object = {}
  endif
  let g:textobj#sandwich#object = deepcopy(s:textobj)
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
  call textobj.opt.arg.update(get(a:000, 0, {}))

  return ":\<C-u>call textobj#sandwich#select()\<CR>"
endfunction
"}}}
function! textobj#sandwich#query(mode, a_or_i, ...) abort  "{{{
  " make new textobj object
  if !exists('g:textobj#sandwich#object')
    let g:textobj#sandwich#object = {}
  endif
  let g:textobj#sandwich#object = deepcopy(s:textobj)
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
  let textobj.opt.timeoutlen = s:get('timeoutlen', &timeoutlen)
  let textobj.opt.timeoutlen = textobj.opt.timeoutlen < 0 ? 0 : textobj.opt.timeoutlen
  call textobj.opt.arg.update(get(a:000, 0, {}))

  " query
  call textobj.query()

  if textobj.recipes.integrated != []
    let cmd = ":\<C-u>call textobj#sandwich#select()\<CR>"
  else
    if a:mode ==# 'o'
      let cmd = "\<Esc>"
    else
      let cmd = "\<Plug>(sandwich-nop)"
    endif
  endif
  return cmd
endfunction
"}}}
function! textobj#sandwich#select() abort  "{{{
  call g:textobj#sandwich#object.start()
endfunction
"}}}



" Objects
function! s:opt_integrate() dict abort  "{{{
  call self.integrated.clear()
  let default = filter(copy(self.default), self.filter)
  let recipe  = filter(copy(self.recipe),  self.filter)
  let arg     = filter(copy(self.arg),     self.filter)
  call extend(self.integrated, self.default, 'force')
  call extend(self.integrated, self.recipe,  'force')
  call extend(self.integrated, self.arg,     'force')
endfunction
"}}}
function! s:opt_clear() dict abort "{{{
  call filter(self, 'v:key ==# "clear" || v:key ==# "update" || v:key ==# "integrate"')
endfunction
"}}}
function! s:opt_update(dict) dict abort "{{{
  call self.clear()
  call extend(self, a:dict, 'keep')
endfunction
"}}}
" opt object  "{{{
let s:opt = {
      \   'clear' : function('s:opt_clear'),
      \   'update': function('s:opt_update'),
      \ }
"}}}

function! s:clock_start() dict abort  "{{{
  if self.started
    if self.paused
      let self.losstime += str2float(reltimestr(reltime(self.pause_at)))
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
  let self.pause_at = reltime()
  let self.paused   = 1
endfunction
"}}}
function! s:clock_erapsed() dict abort "{{{
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
" clock object  "{{{
let s:clock = {
      \   'started' : 0,
      \   'paused'  : 0,
      \   'losstime': 0,
      \   'zerotime': reltime(),
      \   'pause_at': reltime(),
      \   'start'   : function('s:clock_start'),
      \   'pause'   : function('s:clock_pause'),
      \   'erapsed' : function('s:clock_erapsed'),
      \   'stop'    : function('s:clock_stop'),
      \ }
"}}}

function! s:coord_get_inner(buns, cursor, opt) dict abort "{{{
  if a:opt.skip_break
    let virtualedit = &virtualedit
    let &virtualedit = ''
  endif

  call cursor(self.head)
  call search(a:buns[0], 'ce', self.tail[0])
  normal! l
  let self.inner_head = getpos('.')[1:2]

  call cursor(self.tail)
  call search(a:buns[1], 'bc', self.head[0])
  if !a:opt.skip_break && getpos('.')[2] == 1
    normal! hl
  else
    normal! h
  endif
  let self.inner_tail = getpos('.')[1:2]

  if a:opt.skip_break
    let &virtualedit = virtualedit
  endif
endfunction
"}}}
function! s:coord_next() dict abort  "{{{
  call cursor(self.head)
  normal! h
  let self.head = getpos('.')[1:2]
endfunction
"}}}
" coord object"{{{
let s:coord = deepcopy(s:null_4coord)
let s:coord.get_inner = function('s:coord_get_inner')
let s:coord.next = function('s:coord_next')
"}}}

function! s:search_with_nest(textobj) dict abort  "{{{
  let buns  = self.get_buns()
  let range = self.range
  let coord = self.coord
  let opt   = self.opt.integrated
  let visualmark  = self.visualmark
  let stimeoutlen = self.opt.stimeoutlen

  if buns[0] ==# '' || buns[1] ==# ''
    let range.valid = 0
  endif

  if !range.valid | return | endif

  " check whether the cursor is on the buns[1] or not
  call cursor(coord.head)
  let _head = searchpos(buns[1], 'bc', range.top, stimeoutlen)
  let _tail = searchpos(buns[1], 'cen', range.bottom, stimeoutlen)
  if _head != s:null_coord && _tail != s:null_coord && s:is_in_between(coord.head, _head, _tail)
    call cursor(_head)
  else
    call cursor(coord.head)
  endif

  while 1
    " search head
    let flag = searchpos(buns[1], 'cn', range.bottom, stimeoutlen) == getpos('.')[1:2]
          \ ? 'b' : 'bc'
    let head = searchpairpos(buns[0], '', buns[1], flag, 'self.skip(1)', range.top, stimeoutlen)
    if head == s:null_coord | break | endif
    let coord.head = head

    let self.syntax = opt.match_syntax ? [s:get_displaysyntax(head)] : []

    " search tail
    let tail = searchpairpos(buns[0], '', buns[1], '', 'self.skip(0)', range.bottom, stimeoutlen)
    if tail == s:null_coord | break | endif
    let tail = searchpos(buns[1], 'ce', range.bottom, stimeoutlen)
    if tail == s:null_coord | break | endif
    let coord.tail = tail

    call coord.get_inner(buns, self.cursor, opt)

    " add to candidates
    if self.is_valid_candidate(a:textobj)
      let candidate = deepcopy(self)
      " this is required for the case of 'expr' option is 2.
      let candidate.buns[0:1] = buns
      let a:textobj.candidates += [candidate]
    endif

    if coord.head == [1, 1]
      " finish!
      let range.valid = 0
      break
    else
      call coord.next()
    endif
  endwhile
  call range.next()
endfunction
"}}}
function! s:search_without_nest(textobj) dict abort  "{{{
  let buns  = self.get_buns()
  let range = self.range
  let coord = self.coord
  let opt   = self.opt.integrated
  let visualmark  = self.visualmark
  let stimeoutlen = self.opt.stimeoutlen

  if buns[0] ==# '' || buns[1] ==# ''
    let range.valid = 0
  endif

  if !range.valid | return | endif

  " search nearest head
  call cursor(self.cursor)
  let head = self.searchpos(buns[0], 'bc', range.top, stimeoutlen, 1)
  if head == s:null_coord
    call range.next()
    return
  endif
  let _tail = searchpos(buns[0], 'ce', range.bottom, stimeoutlen)

  let self.syntax = opt.match_syntax ? [s:get_displaysyntax(head)] : []

  " search nearest tail
  call cursor(self.cursor)
  let tail = self.searchpos(buns[1], 'ce',  range.bottom, stimeoutlen, 0)
  if tail == s:null_coord
    call range.next()
    return
  endif

  if tail == _tail
    " check whether it is head or tail
    let odd = 1
    call cursor([range.top, 1])
    let pos = searchpos(buns[0], 'c', range.top, stimeoutlen)
    while pos != head && pos != s:null_coord
      let odd = !odd
      let pos = searchpos(buns[0], '', range.top, stimeoutlen)
    endwhile
    if pos == s:null_coord | return | endif

    if odd
      " pos is head
      let head = pos

      let self.syntax = opt.match_syntax ? [s:get_displaysyntax(head)] : []

      " search tail
      call search(buns[0], 'ce', range.bottom, stimeoutlen)
      let tail = self.searchpos(buns[1], 'e',  range.bottom, stimeoutlen, 0)
      if tail == s:null_coord
        call range.next()
        return
      endif
    else
      " pos is tail
      call cursor(pos)
      let tail = self.searchpos(buns[1], 'ce',  range.bottom, stimeoutlen, 1)

      let self.syntax = opt.match_syntax ? [s:get_displaysyntax(tail)] : []

      " search head
      call search(buns[1], 'bc', range.top, stimeoutlen)
      let head = self.searchpos(buns[0], 'b',  range.top, stimeoutlen, 0)
      if head == s:null_coord
        call range.next()
        return
      endif
    endif
  endif

  let coord.head = head
  let coord.tail = tail
  call coord.get_inner(buns, self.cursor, opt)

  if self.is_valid_candidate(a:textobj)
    let candidate = deepcopy(self)
    " this is required for the case of 'expr' option is 2.
    let candidate.buns[0:1] = buns
    let a:textobj.candidates += [candidate]
  endif

  let range.valid = 0
endfunction
"}}}
function! s:get_region(textobj) dict abort "{{{
  let range = self.range
  let coord = self.coord
  let opt   = self.opt.integrated

  if !range.valid | return | endif

  if opt.noremap
    let cmd = 'normal!'
    let v = a:textobj.visualmode
  else
    let cmd = 'normal'
    let v = a:textobj.visualmode ==# 'v' ? "\<Plug>(sandwich-v)" :
          \ a:textobj.visualmode ==# 'V' ? "\<Plug>(sandwich-V)" :
          \ "\<Plug>(sandwich-CTRL-v)"
  endif

  let visualmode = a:textobj.visualmode
  let [visual_head, visual_tail] = [getpos("'<"), getpos("'>")]
  try
    while 1
      let [prev_head, prev_tail] = [coord.head, coord.tail]
      let [prev_inner_head, prev_inner_tail] = [coord.inner_head, coord.inner_tail]
      " get outer positions
      call cursor(self.cursor)
      execute printf("%s %s%d%s", cmd, v, range.count, self.external[1])
      execute "normal! \<Esc>"
      let motionwise_a = visualmode()
      let [head, tail] = [getpos("'<")[1:2], getpos("'>")[1:2]]
      " NOTE: V never comes for v. Thus if head == taik == self.cursor, then
      "       it is failed.
      if head == self.cursor && tail == self.cursor
        let [head, tail] = [copy(s:null_coord), copy(s:null_coord)]
      elseif motionwise_a ==# 'V'
        let tail[2] = col([tail[1], '$'])
      endif

      " get inner positions
      call cursor(self.cursor)
      execute printf("%s %s%d%s", cmd, v, range.count, self.external[0])
      execute "normal! \<Esc>"
      let motionwise_i = visualmode()
      let [inner_head, inner_tail] = [getpos("'<")[1:2], getpos("'>")[1:2]]
      if inner_head == self.cursor && inner_tail == self.cursor
        let [inner_head, inner_tail] = [copy(s:null_coord), copy(s:null_coord)]
      elseif motionwise_i ==# 'V'
        let inner_tail[2] = col([inner_tail[1], '$'])
      endif

      if (self.a_or_i ==# 'i' && inner_head != s:null_coord && inner_tail != s:null_coord && (range.count == 1 || s:is_ahead(prev_inner_head, inner_head) || s:is_ahead(inner_tail, prev_inner_tail)))
       \ || (self.a_or_i ==# 'a' && head != s:null_coord && tail != s:null_coord && (range.count == 1 || s:is_ahead(prev_head, head) || s:is_ahead(tail, prev_tail)))
        if head[0] >= range.top && tail[0] <= range.bottom
          let coord.head = head
          let coord.tail = tail
          let coord.inner_head = inner_head
          let coord.inner_tail = inner_tail

          if self.is_valid_candidate(a:textobj)
            let self.visualmode = self.a_or_i ==# 'a' ? motionwise_a : motionwise_i
            let a:textobj.candidates += [deepcopy(self)]
          endif
        else
          call range.next()
          break
        endif
      else
        let range.valid = 0
        break
      endif

      let range.count += 1
    endwhile
  finally
    " restore visualmode
    execute 'normal! ' . visualmode . "\<Esc>"
    call cursor(self.cursor)
    " restore marks
    call setpos("'<", visual_head)
    call setpos("'>", visual_tail)
  endtry
endfunction
"}}}
function! s:searchpos(pattern, flag, stopline, timeout, is_head) dict abort "{{{
  let flag = a:flag
  if a:pattern !=# ''
    let coord = searchpos(a:pattern, flag, a:stopline, a:timeout)
    let flag = substitute(flag, '\Cc', '', 'g')
    while coord != s:null_coord && self.skip(a:is_head, coord)
      let coord = searchpos(a:pattern, flag, a:stopline, a:timeout)
    endwhile
  else
    let coord = copy(s:null_coord)
  endif
  return coord
endfunction
"}}}
function! s:skip(is_head, ...) dict abort  "{{{
  let cursor = getpos('.')[1:2]
  let coord = a:0 > 0 ? a:1 : cursor
  let opt = self.opt.integrated
  let stimeoutlen = self.opt.stimeoutlen

  if coord == s:null_coord
    return 1
  endif

  if a:is_head || !opt.match_syntax
    if opt.syntax != [] && !s:is_included_syntax(coord, opt.syntax)
      return 1
    endif
  else
    if !s:is_matched_syntax(coord, self.syntax)
      return 1
    endif
  endif

  let skip_patterns = []
  if opt.quoteescape && &quoteescape !=# ''
    for c in split(&quoteescape, '\zs')
      let c = s:escape(c)
      let pattern = printf('[^%s]%s\%%(%s%s\)*\zs\%%#', c, c, c, c)
      let skip_patterns += [pattern]
    endfor
  endif

  let skip_patterns += copy(opt.skip_regex)
  if skip_patterns != []
    call cursor(coord)
    for pattern in skip_patterns
      let skip = searchpos(pattern, 'cn', cursor[0], stimeoutlen) == coord
      if skip
        return 1
      endif
    endfor
  endif

  return 0
endfunction
"}}}
function! s:is_valid_candidate(textobj) dict abort "{{{
  let coord      = self.coord
  let opt        = self.opt.integrated
  let visualmark = self.visualmark

  if self.a_or_i ==# 'i'
    let [head, tail] = [coord.inner_head, coord.inner_tail]
    let filter = 'v:val.coord.inner_head == self.coord.inner_head && v:val.coord.inner_tail == self.coord.inner_tail'
  else
    let [head, tail] = [coord.head, coord.tail]
    let filter = 'v:val.coord.head == self.coord.head && v:val.coord.tail == self.coord.tail'
  endif

  " specific condition in visual mode
  if self.mode !=# 'x'
    let visual_mode_affair = 1
  else
    " self.visualmode ==# 'V' never comes.
    if self.visualmode ==# 'v'
      let visual_mode_affair = s:is_ahead(visualmark.head, head)
                          \ || s:is_ahead(tail, visualmark.tail)
    else
      let orig_pos = getpos('.')
      let visual_head = s:get_displaycoord(visualmark.head)
      let visual_tail = s:get_displaycoord(visualmark.tail)
      call s:set_displaycoord([self.cursor[0], visual_head[1]])
      let thr_head = getpos('.')
      call s:set_displaycoord([self.cursor[0], visual_tail[1]])
      let thr_tail = getpos('.')
      let visual_mode_affair = s:is_ahead(thr_head, head)
                          \ || s:is_ahead(tail, thr_tail)
      call setpos('.', orig_pos)
    endif
  endif

  " specific condition for the option 'matched_syntax'
  if opt.match_syntax != 2
    let opt_match_syntax_affair = 1
  else
    let opt_match_syntax_affair = s:is_included_syntax(coord.inner_head, self.syntax)
                             \ || s:is_included_syntax(coord.inner_tail, self.syntax)
  endif

  return s:is_equal_or_ahead(tail, head)
        \ && s:is_in_between(self.cursor, coord.head, coord.tail)
        \ && filter(copy(a:textobj.candidates), filter) == []
        \ && visual_mode_affair
        \ && opt_match_syntax_affair
endfunction
"}}}
function! s:get_buns() dict abort  "{{{
  let opt   = self.opt.integrated
  let buns  = self.buns
  let clock = self.clock

  if (opt.expr && !self.evaluated) || opt.expr == 2
    call clock.pause()
    echo ''
    let buns = opt.expr == 2 ? deepcopy(buns) : buns
    let buns[0] = eval(buns[0])
    if buns[0] !=# ''
      let buns[1] = eval(buns[1])
    endif
    let self.evaluated = 1
    redraw
    echo ''
    call clock.start()
  endif

  if self.state && !opt.regex && !self.escaped
    call map(buns, 's:escape(v:val)')
    let self.escaped = 1
  endif

  return buns
endfunction
"}}}
function! s:range_next() dict abort  "{{{
  if (self.top == 1/0 && self.bottom < 1)
        \ || (self.top <= self.toplim && self.bottom >= self.botlim)
    let self.top    = 1/0
    let self.bottom = 0
    let self.valid  = 0
  else
    if self.top > self.toplim
      let self.top = self.top - self.stride
      let self.top = self.top < self.toplim ? self.toplim : self.top
    endif
    if self.bottom < self.botlim
      let self.bottom = self.bottom + self.stride
      let self.bottom = self.bottom > self.botlim ? self.botlim : self.bottom
    endif
  endif
endfunction
"}}}
" stuff object "{{{
let s:stuff = {
      \   'buns'    : [],
      \   'external': [],
      \   'searchby': '',
      \   'state'   : 0,
      \   'a_or_i'  : '',
      \   'mode'    : '',
      \   'cursor'  : copy(s:null_coord),
      \   'coord'   : copy(s:coord),
      \   'syntax'  : [],
      \   'opt'     : {},
      \   'clock'   : {},
      \   'range'   : {
      \     'valid' : 0,
      \     'top'   : 0,
      \     'bottom': 0,
      \     'toplim': 0,
      \     'botlim': 0,
      \     'stride': &lines,
      \     'count' : 1,
      \     'next'  : function('s:range_next'),
      \   },
      \   'escaped'  : 0,
      \   'evaluated': 0,
      \   'search_with_nest': function('s:search_with_nest'),
      \   'search_without_nest': function('s:search_without_nest'),
      \   'get_region': function('s:get_region'),
      \   'searchpos': function('s:searchpos'),
      \   'skip': function('s:skip'),
      \   'is_valid_candidate': function('s:is_valid_candidate'),
      \   'get_buns': function('s:get_buns'),
      \ }
"}}}

function! s:query() dict abort  "{{{
  call self.recipes.integrate(self.kind, self.mode, self.opt.default)
  let recipes = deepcopy(self.recipes.integrated)
  let clock   = self.clock
  let timeoutlen = self.opt.timeoutlen

  " query phase
  let input   = ''
  let cmdline = []
  let last_compl_match = ['', []]
  while recipes != []
    let c = getchar(0)
    if c == 0
      if clock.started && timeoutlen > 0 && clock.erapsed() > timeoutlen
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
    let n_fwd = len(filter(recipes, 's:is_input_matched(v:val, input, 0)'))

    " check complete match
    let n_comp = len(filter(copy(recipes), 's:is_input_matched(v:val, input, 1)'))
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
  endwhile
  call clock.stop()

  " pick up and register a recipe
  if filter(recipes, 's:is_input_matched(v:val, input, 1)') != []
    let recipe = recipes[0]
  else
    if input ==# "\<Esc>" || input ==# "\<C-c>" || input ==# ''
      let recipe = {}
    else
      let c = split(input, '\zs')[0]
      let recipe = {'buns': [c, c]}
    endif
  endif

  if has_key(recipe, 'buns') || has_key(recipe, 'external')
    let self.recipes.integrated = [recipe]
  else
    let self.recipes.integrated = []
  endif
endfunction
"}}}
function! s:start() dict abort "{{{
  call self.initialize()

  let [virtualedit, whichwrap]   = [&virtualedit, &whichwrap]
  let [&virtualedit, &whichwrap] = ['onemore', 'h,l']
  try
    call self.select()
  finally
    call self.finalize()
    let [&virtualedit, &whichwrap] = [virtualedit, whichwrap]
  endtry
endfunction
"}}}
function! s:initialize() dict abort  "{{{
  let self.count = !self.state && self.count != v:count1 ? v:count1 : self.count
  let self.done  = 0

  if self.mode ==# 'x'
    let self.visualmark.head = getpos("'<")[1:2]
    let self.visualmark.tail = getpos("'>")[1:2]
  endif

  if self.state
    let self.opt.stimeoutlen = s:get('stimeoutlen', 500)
    let self.opt.stimeoutlen = self.opt.stimeoutlen < 0 ? 0 : self.opt.stimeoutlen
    let self.opt.latestjump  = s:get('latest_jump', 1)
    let self.visualmode = self.mode ==# 'x' && visualmode() ==# "\<C-v>" ? "\<C-v>" : 'v'
    call self.opt.default.update(deepcopy(g:textobj#sandwich#options[self.kind]))

    if self.recipes.integrated == []
      call self.recipes.integrate(self.kind, self.mode, self.opt.default)
    endif
    let recipes = self.recipes.integrated

    " prepare basket
    for recipe in recipes
      let has_buns     = has_key(recipe, 'buns')
      let has_external = has_key(recipe, 'external')
      if has_buns || has_external
        let stuff = deepcopy(s:stuff)

        if has_buns
          let stuff.buns     = remove(recipe, 'buns')
          let stuff.searchby = 'buns'
        else
          let stuff.external = remove(recipe, 'external')
          let stuff.searchby = 'external'
        endif

        let stuff.state  = self.state
        let stuff.a_or_i = self.a_or_i
        let stuff.mode   = self.mode
        let stuff.cursor = self.cursor
        let stuff.clock  = self.clock
        let stuff.evaluated  = 0
        let stuff.visualmode = self.visualmode
        let stuff.coord.head = copy(self.cursor)
        let stuff.visualmark = self.visualmark

        let stuff.opt      = copy(self.opt)
        let opt            = stuff.opt
        let opt.filter     = printf('v:key =~# ''\%%(%s\)''',
                \ join(keys(s:default_opt[self.kind]), '\|'))
        let opt.recipe     = deepcopy(s:opt)
        let opt.integrated = deepcopy(s:opt)
        let opt.integrate  = function('s:opt_integrate')
        call opt.recipe.update(recipe)
        call opt.integrate()

        let range        = stuff.range
        let range.valid  = 1
        let range.top    = self.cursor[0]
        let range.bottom = self.cursor[0]
        let lineend      = line('$')
        if opt.integrated.expand_range >= 0
          let range.toplim = self.cursor[0] - opt.integrated.expand_range
          let range.toplim = range.toplim < 1 ? 1 : range.toplim
          let range.botlim = self.cursor[0] + opt.integrated.expand_range
          let range.botlim = range.botlim > lineend ? lineend : range.botlim
        else
          let range.toplim = 1
          let range.botlim = lineend
        endif

        let self.basket += [stuff]
      endif
    endfor
  else
    let self.cursor = getpos('.')[1:2]
    let self.view   = winsaveview()

    " prepare basket
    for stuff in self.basket
      let stuff.state  = self.state
      let stuff.cursor = self.cursor
      let stuff.coord.head = copy(self.cursor)
      let stuff.coord.tail = copy(s:null_coord)
      let stuff.coord.inner_head = copy(s:null_coord)
      let stuff.coord.inner_tail = copy(s:null_coord)

      let opt          = stuff.opt
      let range        = stuff.range
      let range.valid  = 1
      let range.top    = self.cursor[0]
      let range.bottom = self.cursor[0]
      let lineend      = line('$')
      if opt.integrated.expand_range >= 0
        let range.toplim = self.cursor[0] - opt.integrated.expand_range
        let range.toplim = range.toplim < 1 ? 1 : range.toplim
        let range.botlim = self.cursor[0] + opt.integrated.expand_range
        let range.botlim = range.botlim > lineend ? lineend : range.botlim
      else
        let range.toplim = 1
        let range.botlim = lineend
      endif
      let range.count = 1
    endfor
  endif

  let self.candidates = []
endfunction
"}}}
function! s:select() dict abort  "{{{
  let clock = self.clock
  let stimeoutlen = self.opt.stimeoutlen

  " start stopwatch
  call clock.start()

  " gather candidate
  while filter(copy(self.basket), 'v:val.range.valid') != []
    for stuff in self.basket
      if stuff.searchby ==# 'buns'
        if stuff.opt.integrated.nesting
          call stuff.search_with_nest(self)
        else
          call stuff.search_without_nest(self)
        endif
      elseif stuff.searchby ==# 'external'
        call stuff.get_region(self)
      else
        let stuff.range.valid = 0
      endif
    endfor

    if len(self.candidates) >= self.count
      break
    endif

    " time out
    if clock.started && stimeoutlen > 0
      let erapsed = clock.erapsed()
      if erapsed > stimeoutlen
        echo 'textobj-sandwich: Timed out.'
        break
      endif
    endif
  endwhile
  call clock.stop()

  if len(self.candidates) >= self.count
    " election
    let map_rule = printf(
          \   'extend(v:val,
          \     {"len": s:get_buf_length(v:val.coord.%s, v:val.coord.%s)}
          \   )',
          \   'inner_head',
          \   'inner_tail'
          \ )
    call map(self.candidates, map_rule)
    call s:sort(self.candidates, 's:compare_buf_length', self.count)
    let elected = self.candidates[self.count - 1]

    " restore view
    call winrestview(self.view)

    " select
    let head = self.a_or_i ==# 'i' ? elected.coord.inner_head : elected.coord.head
    let tail = self.a_or_i ==# 'i' ? elected.coord.inner_tail : elected.coord.tail
    if self.mode ==# 'x' && self.visualmode ==# "\<C-v>"
      " trick for the blockwise visual mode
      if self.cursor[0] == self.visualmark.tail[0]
        let disp_coord = s:get_displaycoord(head)
        let disp_coord[0] = self.visualmark.head[0]
        call s:set_displaycoord(disp_coord)
        let head = getpos('.')[1:2]
      elseif self.cursor[0] == self.visualmark.head[0]
        let disp_coord = s:get_displaycoord(tail)
        let disp_coord[0] = self.visualmark.tail[0]
        call s:set_displaycoord(disp_coord)
        let tail = getpos('.')[1:2]
      endif
    endif

    execute 'normal! ' . elected.visualmode
    call cursor(head)
    normal! o
    call cursor(tail)

    " counter measure for the 'selection' option being 'exclusive'
    if &selection ==# 'exclusive'
      normal! l
    endif

    " For the cooperation with operator-sandwich
    " NOTE: After visual selection by a user-defined textobject, v:operator is set as ':'
    " NOTE: 'synchro' option is not valid for visual mode, because there is no guarantee that g:operator#sandwich#object exists.
    if elected.opt.integrated.synchro && exists('g:operator#sandwich#object')
          \ && ((elected.searchby == 'buns' && v:operator ==# 'g@') || (elected.searchby == 'external' && v:operator =~# '\%(:\|g@\)'))
          \ && &operatorfunc =~# '^operator#sandwich#\%(delete\|replace\)'
      call self.synchronize(elected)
    endif

    let self.done = 1
  else
    if self.mode ==# 'x'
      normal! gv
    endif
  endif
endfunction
"}}}
function! s:synchronize(elected) abort "{{{
  let recipe = {}
  if a:elected.searchby ==# 'buns'
    call extend(recipe, {'buns': a:elected.buns})
  elseif a:elected.searchby ==# 'external'
    call extend(recipe, {'external': a:elected.external})
    call extend(recipe, {'excursus': [a:elected.range.count, [0] + a:elected.cursor + [0]]})
  endif
  let filter = 'v:key !=# "clear" && v:key !=# "update"'
  call extend(recipe, filter(a:elected.opt.recipe, filter))

  " If the recipe has 'kind' key and has no 'delete', 'replace' keys, then add these items.
  if has_key(recipe, 'kind') && filter(copy(recipe.kind), 'v:val ==# "delete" || v:val ==# "replace"') == []
    let recipe.kind += ['delete', 'replace']
  endif

  " Add 'delete' item to 'action' filter, if the recipe is not valid in 'delete' action.
  if has_key(recipe, 'action') && filter(copy(recipe.action), 'v:val ==# "delete"') == []
    let recipe.action += ['delete']
  endif

  let g:operator#sandwich#object.recipes.synchro = [recipe]
endfunction
"}}}
function! s:finalize() dict abort "{{{
  if self.opt.latestjump
    call setpos("''", [0] + self.cursor + [0])
  endif

  if !self.done
    call winrestview(self.view)
  endif

  " flash echoing
  if !self.state
    echo ''
  endif

  let self.state = 0
endfunction
"}}}
function! s:recipes_integrate(kind, mode, opt) dict abort  "{{{
  let self.integrated  = []
  if self.arg != []
    let self.integrated += self.arg
  else
    let self.integrated += sandwich#get_recipes()
    let self.integrated += textobj#sandwich#get_recipes()
  endif
  let filter = 's:has_filetype(v:val)
           \ && s:has_kind(v:val, a:kind)
           \ && s:has_mode(v:val, a:mode)
           \ && s:expr_filter(v:val)'
  call filter(self.integrated, filter)
  call reverse(self.integrated)

  " uniq by buns
  if a:kind ==# 'auto'
    let recipes = copy(self.integrated)
    let self.integrated = []
    while recipes != []
      let recipe = remove(recipes, 0)
      let self.integrated += [recipe]
      if has_key(recipe, 'buns')
        call filter(recipes, '!s:is_duplicated_buns(recipe, v:val, a:opt)')
      elseif has_key(recipe, 'external')
        call filter(recipes, '!s:is_duplicated_external(recipe, v:val, a:opt)')
      endif
    endwhile
  endif
endfunction
"}}}
" textobj object  "{{{
let s:textobj = {
      \   'state'     : 0,
      \   'kind'      : '',
      \   'a_or_i'    : 'i',
      \   'mode'      : '',
      \   'count'     : 0,
      \   'cursor'    : copy(s:null_coord),
      \   'view'      : {},
      \   'recipes'   : {
      \     'arg'       : [],
      \     'integrated': [],
      \     'integrate' : function('s:recipes_integrate'),
      \   },
      \   'basket'    : [],
      \   'candidates': [],
      \   'visualmode': 'v',
      \   'visualmark': copy(s:null_2coord),
      \   'opt'       : {
      \     'stimeoutlen': 0,
      \     'arg'    : copy(s:opt),
      \     'default': copy(s:opt),
      \   },
      \   'done'      : 0,
      \   'clock'     : copy(s:clock),
      \   'query'     : function('s:query'),
      \   'start'     : function('s:start'),
      \   'initialize': function('s:initialize'),
      \   'select'    : function('s:select'),
      \   'synchronize': function('s:synchronize'),
      \   'finalize'  : function('s:finalize'),
      \ }
"}}}

""" Private funcs
function! s:has_filetype(candidate) abort "{{{
  if !has_key(a:candidate, 'filetype')
    return 1
  else
    let filetypes = split(&filetype, '\.')
    let filter = 'v:val ==# "all" || match(filetypes, v:val) > -1'
    return filter(copy(a:candidate['filetype']), filter) != []
  endif
endfunction
"}}}
function! s:has_kind(candidate, kind) abort "{{{
  if !has_key(a:candidate, 'kind')
    return 1
  else
    let filter = 'v:val ==# a:kind || v:val ==# "textobj" || v:val ==# "all"'
    return filter(copy(a:candidate['kind']), filter) != []
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
function! s:is_duplicated_buns(recipe, item, opt) abort  "{{{
  if has_key(a:item, 'buns')
        \ && a:recipe['buns'][0] ==# a:item['buns'][0]
        \ && a:recipe['buns'][1] ==# a:item['buns'][1]
    let regex_r   = get(a:recipe, 'regex',   a:opt.regex)
    let regex_i   = get(a:item,   'regex',   a:opt.regex)
    let expr_r    = get(a:recipe, 'expr',    a:opt.expr)
    let expr_i    = get(a:item,   'expr',    a:opt.expr)

    let expr_r = expr_r ? 1 : 0
    let expr_i = expr_i ? 1 : 0

    if regex_r == regex_i && expr_r == expr_i
      return 1
    endif
  endif

  return 0
endfunction
"}}}
function! s:is_duplicated_external(recipe, item, opt) abort "{{{
  if has_key(a:item, 'external')
        \ && a:recipe['external'][0] ==# a:item['external'][0]
        \ && a:recipe['external'][1] ==# a:item['external'][1]
    let noremap_r = get(a:recipe, 'noremap', a:opt.noremap)
    let noremap_i = get(a:item,   'noremap', a:opt.noremap)

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
function! s:get_buf_length(start, end) abort  "{{{
  if a:start[0] == a:end[0]
    let len = a:end[1] - a:start[1] + 1
  else
    let length_list = map(getline(a:start[0], a:end[0]), 'len(v:val) + 1')
    let idx = 0
    let accumm_length = 0
    let accumm_list   = [0]
    for length in length_list[1:]
      let accumm_length  = accumm_length + length_list[idx]
      let accumm_list   += [accumm_length]
      let idx += 1
    endfor
    let len = accumm_list[a:end[0] - a:start[0]] + a:end[1] - a:start[1] + 1
  endif
  return len
endfunction
"}}}
function! s:compare_buf_length(i1, i2) abort  "{{{
  return a:i1.len - a:i2.len
endfunction
"}}}
function! s:escape(string) abort  "{{{
  return escape(a:string, '~"\.^$[]*')
endfunction
"}}}
function! s:is_matched_syntax(coord, syntaxID) abort  "{{{
  if a:coord == s:null_coord
    return 0
  elseif a:syntaxID == []
    return 1
  else
    return [s:get_displaysyntax(a:coord)] == a:syntaxID
  endif
endfunction
"}}}
function! s:is_included_syntax(coord, syntaxID) abort  "{{{
  let synstack = map(synstack(a:coord[0], a:coord[1]),
        \ 'synIDattr(synIDtrans(v:val), "name")')

  if a:syntaxID == []
    return 1
  elseif synstack == []
    if a:syntaxID == ['']
      return 1
    else
      return 0
    endif
  else
    return filter(copy(a:syntaxID), 'match(synstack, v:val) > -1') != []
  endif
endfunction
"}}}
function! s:is_in_between(coord, head, tail) abort  "{{{
  return (a:coord != s:null_coord) && (a:head != s:null_coord) && (a:tail != s:null_coord)
    \  && ((a:coord[0] > a:head[0]) || ((a:coord[0] == a:head[0]) && (a:coord[1] >= a:head[1])))
    \  && ((a:coord[0] < a:tail[0]) || ((a:coord[0] == a:tail[0]) && (a:coord[1] <= a:tail[1])))
endfunction
"}}}
function! s:is_ahead(coord1, coord2) abort  "{{{
  return a:coord1[0] > a:coord2[0] || (a:coord1[0] == a:coord2[0] && a:coord1[1] > a:coord2[1])
endfunction
"}}}
function! s:is_equal_or_ahead(coord1, coord2) abort  "{{{
  return a:coord1[0] > a:coord2[0] || (a:coord1[0] == a:coord2[0] && a:coord1[1] >= a:coord2[1])
endfunction
"}}}
function! s:is_input_matched(candidate, input, flag) abort "{{{
  let has_buns = has_key(a:candidate, 'buns')
  let has_ext  = has_key(a:candidate, 'external') && has_key(a:candidate, 'input')
  if !(has_buns || has_ext)
    return 0
  elseif !a:flag && a:input ==# ''
    return 1
  endif

  " If a:flag == 0, check forward match. Otherwise, check complete match.
  let candidate = deepcopy(a:candidate)
  if has_buns
    let inputs = get(candidate, 'input', candidate['buns'])
  elseif has_ext
    let inputs = a:candidate['input']
  endif
  if a:flag
    return filter(inputs, 'v:val ==# a:input') != []
  else
    let idx = strlen(a:input) - 1
    return filter(inputs, 'v:val[: idx] ==# a:input') != []
  endif
endfunction
"}}}
function! s:get_displaycoord(coord) abort "{{{
  let [lnum, col] = a:coord

  if [lnum, col] != s:null_coord
    if col == 1
      let disp_col = 1
    else
      let disp_col = strdisplaywidth(getline(lnum)[: col - 2]) + 1
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
function! s:get_displaysyntax(coord) abort  "{{{
  return synIDattr(synIDtrans(synID(a:coord[0], a:coord[1], 1)), 'name')
endfunction
"}}}
" function! s:sort(list, func, count) abort  "{{{
if s:has_patch_7_4_358
  function! s:sort(list, func, count) abort
    return sort(a:list, a:func)
  endfunction
else
  function! s:sort(list, func, count) abort
    " NOTE: len(a:list) is always larger than count or same.
    " FIXME: The number of item in a:list would not be large, but if there was
    "        any efficient argorithm, I would rewrite here.
    let len = len(a:list)
    for i in range(a:count)
      if len - 2 >= i
        let min = len - 1
        for j in range(len - 2, i, -1)
          if a:list[min]['len'] >= a:list[j]['len']
            let min = j
          endif
        endfor

        if min > i
          call insert(a:list, remove(a:list, min), i)
        endif
      endif
    endfor
    return a:list
  endfunction
endif
"}}}

" recipe  "{{{
function! textobj#sandwich#get_recipes() abort  "{{{
  let default = exists('g:textobj#sandwich#no_default_recipes')
            \ ? [] : g:textobj#sandwich#default_recipes
  return deepcopy(s:get('recipes', default))
endfunction
"}}}
if exists('g:textobj#sandwich#default_recipes')
  unlockvar! g:textobj#sandwich#default_recipes
endif
let g:textobj#sandwich#default_recipes = [
      \   {'buns': ['input("textobj-sandwich:head: ")', 'input("textobj-sandwich:tail: ")'], 'kind': ['query'], 'expr': 1, 'regex': 1, 'synchro': 1, 'input': ['i']},
      \ ]
lockvar! g:textobj#sandwich#default_recipes
"}}}

" options "{{{
let s:default_opt = {}
let s:default_opt.auto = {
      \   'expr'         : 0,
      \   'regex'        : 0,
      \   'skip_regex'   : [],
      \   'quoteescape'  : 0,
      \   'expand_range' : -1,
      \   'nesting'      : 0,
      \   'synchro'      : 0,
      \   'noremap'      : 1,
      \   'syntax'       : [],
      \   'match_syntax' : 0,
      \   'skip_break'   : 0,
      \ }
let s:default_opt.query = {
      \   'expr'         : 0,
      \   'regex'        : 0,
      \   'skip_regex'   : [],
      \   'quoteescape'  : 0,
      \   'expand_range' : -1,
      \   'nesting'      : 0,
      \   'synchro'      : 0,
      \   'noremap'      : 1,
      \   'syntax'       : [],
      \   'match_syntax' : 0,
      \   'skip_break'   : 0,
      \ }
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
  if !(a:kind ==# 'auto' || a:kind ==# 'query' || a:kind ==# 'all')
    echohl WarningMsg
    echomsg 'Invalid kind "' . a:kind . '".'
    echohl NONE
    return
  endif

  if filter(keys(s:default_opt[a:kind]), 'v:val ==# a:option') == []
    echohl WarningMsg
    echomsg 'Invalid option name "' . a:kind . '".'
    echohl NONE
    return
  endif

  if type(a:value) != type(s:default_opt[a:kind][a:option])
    echohl WarningMsg
    echomsg 'Invalid type of value. ' . string(a:value)
    echohl NONE
    return
  endif

  if a:kind ==# 'all'
    let kinds = ['auto', 'query']
  else
    let kinds = [a:kind]
  endif

  for kind in kinds
    let g:textobj#sandwich#options[a:kind][a:option] = a:value
  endfor
endfunction
"}}}
"}}}

unlet! g:textobj#sandwich#object


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
