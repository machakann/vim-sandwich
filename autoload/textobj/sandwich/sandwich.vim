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

" common functions
let s:lib = textobj#sandwich#lib#get()
"}}}

function! textobj#sandwich#sandwich#new(recipe, opt) abort  "{{{
  let sandwich = deepcopy(s:sandwich)
  let sandwich.opt = copy(a:opt)
  let sandwich.opt.recipe = {}
  call sandwich.opt.update('recipe', a:recipe)
  let opt = sandwich.opt

  if has_key(a:recipe, 'buns')
    let sandwich.searchby = 'buns'
    let sandwich.buns = deepcopy(a:recipe.buns)
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
      \   'recipe'    : {},
      \   'external'  : [],
      \   'searchby'  : '',
      \   'coord'     : deepcopy(s:coord),
      \   'range'     : deepcopy(s:range),
      \   'visualmode': '',
      \   'syntax'    : [],
      \   'opt'       : {},
      \   'escaped'   : 0,
      \   'evaluated' : 0,
      \   'synchro_buns': [],
      \ }
"}}}
function! s:sandwich.initialize(cursor) dict abort "{{{
  call self.coord.initialize()
  call self.range.initialize(a:cursor, self.opt.of('expand_range'))
endfunction
"}}}
function! s:sandwich.get_buns(state, clock) dict abort  "{{{
  let opt_listexpr = self.opt.of('listexpr')
  let opt_expr = self.opt.of('expr')
  let opt_regex = self.opt.of('regex')

  call a:clock.pause()
  if opt_listexpr == 2
    let buns = eval(self.buns)
  elseif opt_listexpr == 1 && !self.evaluated
    let buns = eval(self.buns)
    unlet self.buns
    let self.buns = buns
    let self.evaluated = 1
  elseif opt_expr == 2
    let buns = ['', '']
    let buns[0] = eval(self.buns[0])
    if buns[0] !=# ''
      let buns[1] = eval(self.buns[1])
    endif
  elseif opt_expr == 1 && !self.evaluated
    let buns = self.buns
    let buns[0] = eval(buns[0])
    if buns[0] !=# ''
      let buns[1] = eval(buns[1])
    endif
    let self.evaluated = 1
  else
    let buns = self.buns
  endif
  call a:clock.start()

  if !s:valid_buns(buns)
    return ['', '']
  endif

  if !self.escaped
    let self.synchro_buns = copy(buns)
    if a:state && !opt_regex
      call map(buns, 's:lib.escape(v:val)')
      if buns is self.buns
        let self.escaped = 1
      endif
    endif
  endif
  return buns
endfunction
"}}}
function! s:sandwich.export_recipe(cursor) dict abort  "{{{
  " For the cooperation with operator-sandwich
  " NOTE: After visual selection by a user-defined textobject, v:operator is set as ':'
  " NOTE: 'synchro' option is not valid for visual mode, because there is no guarantee that g:operator#sandwich#object exists.
  if self.opt.of('synchro') && exists('g:operator#sandwich#object')
        \ && ((self.searchby ==# 'buns' && v:operator ==# 'g@') || (self.searchby ==# 'external' && v:operator =~# '\%(:\|g@\)'))
        \ && &operatorfunc =~# '^operator#sandwich#\%(delete\|replace\)'
    let recipe = self.recipe
    if self.searchby ==# 'buns'
      call extend(recipe, {'buns': self.synchro_buns}, 'force')
      call extend(recipe, {'expr': 0}, 'force')
      call extend(recipe, {'listexpr': 0}, 'force')
    elseif self.searchby ==# 'external'
      let excursus = {
            \   'count' : self.range.count,
            \   'cursor': s:lib.c2p(a:cursor),
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

function! s:valid_buns(buns) abort  "{{{
  return type(a:buns) == s:type_list && s:check_a_bun(a:buns[0]) && s:check_a_bun(a:buns[1])
endfunction
"}}}
function! s:check_a_bun(bun) abort  "{{{
  let type_bun = type(a:bun)
  return type_bun ==# s:type_num || (type_bun ==# s:type_str && a:bun !=# '')
endfunction
"}}}



" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
