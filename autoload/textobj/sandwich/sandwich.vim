" sandwich object - manage recipe and positions of a sandwiched text

" variables "{{{
" null valiables
let s:null_coord  = [0, 0]
let s:null_4coord = {
      \   'head': copy(s:null_coord),
      \   'tail': copy(s:null_coord),
      \   'inner_head': copy(s:null_coord),
      \   'inner_tail': copy(s:null_coord),
      \ }

" types
let s:type_num = type(0)
let s:type_str = type('')
let s:type_list = type([])
let s:type_fref = type(function('tr'))

" common functions
let s:lib = textobj#sandwich#lib#import()
"}}}

function! textobj#sandwich#sandwich#new(recipe, opt) abort  "{{{
  let sandwich = deepcopy(s:sandwich)
  let sandwich.opt = copy(a:opt)
  let sandwich.opt.recipe = {}
  call sandwich.opt.update('recipe', a:recipe)

  if has_key(a:recipe, 'buns')
    let sandwich.searchby = 'buns'
    unlet sandwich.dough
    let sandwich.dough = deepcopy(a:recipe.buns)
  elseif has_key(a:recipe, 'external')
    let sandwich.searchby = 'external'
    let sandwich.external = deepcopy(a:recipe.external)
  else
    return {}
  endif
  let sandwich.recipe = a:recipe
  return sandwich
endfunction
"}}}

" coord object"{{{
let s:coord = deepcopy(s:null_4coord)
function! s:coord.initialize() dict abort "{{{
  let self.head = deepcopy(s:null_coord)
  let self.tail = deepcopy(s:null_coord)
endfunction
"}}}
function! s:coord.get_inner(buns, skip_break) dict abort "{{{
  call cursor(self.head)
  call search(a:buns[0], 'ce', self.tail[0])
  normal! l
  if a:skip_break && col('.') == col([line('.'), '$'])
    let self.inner_head = searchpos('\_S', '', self.tail[0])
  else
    let self.inner_head = getpos('.')[1:2]
  endif

  call cursor(self.tail)
  call search(a:buns[1], 'bc', self.head[0])
  if a:skip_break && (col('.') < 2 || getline(line('.'))[: col('.')-2] =~# '^\s*$')
    let self.inner_tail = searchpos('\_S', 'be', self.head[0])
  else
    if getpos('.')[2] == 1
      normal! hl
    else
      normal! h
    endif
    let self.inner_tail = getpos('.')[1:2]
  endif
endfunction
"}}}
function! s:coord.next() dict abort  "{{{
  call cursor(self.head)
  normal! h
  let self.head = getpos('.')[1:2]
endfunction
"}}}
"}}}
" range object"{{{
let s:range = {
      \   'valid'     : 0,
      \   'top'       : 0,
      \   'bottom'    : 0,
      \   'toplim'    : 0,
      \   'botlim'    : 0,
      \   'stride'    : &lines,
      \   'count'     : 1,
      \ }
function! s:range.initialize(cursor, expand_range) dict abort "{{{
  let filehead    = 1
  let fileend     = line('$')
  let self.valid  = 1
  let self.top    = a:cursor[0]
  let self.bottom = a:cursor[0]
  if a:expand_range >= 0
    let self.toplim = max([filehead, a:cursor[0] - a:expand_range])
    let self.botlim = min([a:cursor[0] + a:expand_range, fileend])
  else
    let self.toplim = filehead
    let self.botlim = fileend
  endif
  let self.count = 1
endfunction
"}}}
function! s:range.next() dict abort  "{{{
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
"}}}

" s:sandwich "{{{
let s:sandwich = {
      \   'buns'      : [],
      \   'dough'     : [],
      \   'external'  : [],
      \   'searchby'  : '',
      \   'recipe'    : {},
      \   'cursor'    : copy(s:null_coord),
      \   'coord'     : deepcopy(s:coord),
      \   'range'     : deepcopy(s:range),
      \   'visualmode': '',
      \   'syntax_on' : 1,
      \   'syntax'    : [],
      \   'opt'       : {},
      \   'escaped'   : 0,
      \   'not_escaped': [],
      \ }
"}}}
function! s:sandwich.initialize(cursor, is_syntax_on) dict abort "{{{
  let self.syntax_on = a:is_syntax_on
  let self.cursor = a:cursor
  call self.coord.initialize()
  call self.range.initialize(a:cursor, self.opt.of('expand_range'))
  return self
endfunction
"}}}
function! s:sandwich.bake_buns(state, clock) dict abort  "{{{
  let opt_listexpr = self.opt.of('listexpr')
  let opt_expr = self.opt.of('expr')
  let opt_regex = self.opt.of('regex')

  call a:clock.pause()
  if a:state
    if opt_listexpr
      let self.buns = eval(self.dough)
    elseif opt_expr
      let self.buns = s:evalexpr(self.dough)
    else
      let self.buns = self.dough
    endif
  else
    if opt_listexpr >= 2
      let self.buns = eval(self.dough)
      let self.escaped = 0
    elseif opt_expr >= 2
      let self.buns = s:evalexpr(self.dough)
      let self.escaped = 0
    endif
  endif
  call a:clock.start()

  if !s:valid_buns(self.buns)
    return ['', '']
  endif

  if !self.escaped
    let self.not_escaped = copy(self.buns)
    if !opt_regex
      call map(self.buns, 's:lib.escape(v:val)')
      let self.escaped = 1
    endif
  endif
  return self.buns
endfunction
"}}}
function! s:sandwich.searchpair_head(stimeoutlen) dict abort "{{{
  let tailpos = searchpos(self.buns[1], 'cn', self.range.bottom, a:stimeoutlen)
  let flag = tailpos == getpos('.')[1:2] ? 'b' : 'bc'
  let stopline = self.range.top
  return searchpairpos(self.buns[0], '', self.buns[1], flag, 'self.skip(1)', stopline, a:stimeoutlen)
endfunction
"}}}
function! s:sandwich.searchpair_tail(stimeoutlen) dict abort "{{{
  let stopline = self.range.bottom
  return searchpairpos(self.buns[0], '', self.buns[1], '', 'self.skip(0)', stopline, a:stimeoutlen)
endfunction
"}}}
function! s:sandwich.search_head(flag, stimeoutlen) dict abort "{{{
  return self._searchpos(self.buns[0], a:flag, 1, self.range.top, a:stimeoutlen)
endfunction
"}}}
function! s:sandwich.search_tail(flag, stimeoutlen) dict abort "{{{
  return self._searchpos(self.buns[1], a:flag, 0, self.range.bottom, a:stimeoutlen)
endfunction
"}}}
function! s:sandwich._searchpos(pattern, flag, is_head, stopline, stimeoutlen) dict abort "{{{
  let coord = searchpos(a:pattern, a:flag, a:stopline, a:stimeoutlen)
  let flag = substitute(a:flag, '\m\Cc', '', 'g')
  while coord != s:null_coord && self.skip(a:is_head, coord)
    let coord = searchpos(a:pattern, flag, a:stopline, a:stimeoutlen)
  endwhile
  return coord
endfunction
"}}}
function! s:sandwich.skip(is_head, ...) dict abort "{{{
  " NOTE: for sandwich.searchpairpos()/sandwich.searchpos() functions.
  let opt = self.opt
  let checkpos = get(a:000, 0, getpos('.')[1:2])

  if checkpos == s:null_coord
    return 1
  endif

  " quoteescape option
  let skip_patterns = []
  if opt.of('quoteescape') && &quoteescape !=# ''
    for c in split(&quoteescape, '\zs')
      let c = s:lib.escape(c)
      let pattern = printf('[^%s]%s\%%(%s%s\)*\zs\%%#', c, c, c, c)
      let skip_patterns += [pattern]
    endfor
  endif

  " skip_regex option
  let skip_patterns += opt.of('skip_regex')
  let skip_patterns += a:is_head ? opt.of('skip_regex_head') : opt.of('skip_regex_tail')
  if skip_patterns != []
    call cursor(checkpos)
    for pattern in skip_patterns
      let skip = searchpos(pattern, 'cn', checkpos[0]) == checkpos
      if skip
        return 1
      endif
    endfor
  endif

  " syntax, match_syntax option
  if self.syntax_on
    if a:is_head || !opt.of('match_syntax')
      let opt_syntax = opt.of('syntax')
      if opt_syntax != [] && !s:lib.is_included_syntax(checkpos, opt_syntax)
        return 1
      endif
    else
      if !s:lib.is_matched_syntax(checkpos, self.syntax)
        return 1
      endif
    endif
  endif

  " skip_expr option
  for Expr in opt.of('skip_expr')
    if s:eval(Expr, a:is_head, s:lib.c2p(checkpos))
      return 1
    endif
  endfor

  return 0
endfunction
"}}}
function! s:sandwich.check_syntax(coord) dict abort "{{{
  if !self.syntax_on || !self.opt.of('match_syntax')
    return
  endif

  let synitem = s:lib.get_displaysyntax(a:coord)
  if synitem !=# ''
    let self.syntax = [synitem]
  endif
endfunction
"}}}
function! s:sandwich.export_recipe() dict abort  "{{{
  " For the cooperation with operator-sandwich
  " NOTE: After visual selection by a user-defined textobject, v:operator is set as ':'
  " NOTE: 'synchro' option is not valid for visual mode, because there is no guarantee that g:operator#sandwich#object exists.
  if self.opt.of('synchro') && exists('g:operator#sandwich#object')
        \ && ((self.searchby ==# 'buns' && v:operator ==# 'g@') || (self.searchby ==# 'external' && v:operator =~# '\%(:\|g@\)'))
        \ && &operatorfunc =~# '^operator#sandwich#\%(delete\|replace\)'
    let recipe = self.recipe
    if self.searchby ==# 'buns'
      call extend(recipe, {'buns': self.not_escaped}, 'force')
      call extend(recipe, {'expr': 0}, 'force')
      call extend(recipe, {'listexpr': 0}, 'force')
    elseif self.searchby ==# 'external'
      let excursus = {
            \   'count' : self.range.count,
            \   'cursor': s:lib.c2p(self.cursor),
            \   'coord' : self.coord,
            \ }
      call extend(recipe, {'excursus': excursus}, 'force')
    endif
    call extend(recipe, {'action': ['delete']}, 'force')
  else
    let recipe = {}
  endif
  return recipe
endfunction
"}}}

function! s:evalexpr(dough) abort "{{{
  let buns = []
  let buns += [eval(a:dough[0])]
  if buns[0] !=# ''
    let buns += [eval(a:dough[1])]
  endif
  return buns
endfunction
"}}}
function! s:valid_buns(buns) abort  "{{{
  return type(a:buns) == s:type_list && len(a:buns) >= 2 && s:check_a_bun(a:buns[0]) && s:check_a_bun(a:buns[1])
endfunction
"}}}
function! s:check_a_bun(bun) abort  "{{{
  let type_bun = type(a:bun)
  return (type_bun ==# s:type_str && a:bun !=# '') || type_bun ==# s:type_num
endfunction
"}}}
function! s:eval(expr, ...) abort "{{{
  return type(a:expr) == s:type_fref ? call(a:expr, a:000) : eval(a:expr)
endfunction
"}}}



" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
