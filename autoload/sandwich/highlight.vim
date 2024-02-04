" highlight object - managing highlight on a buffer

" variables "{{{
" null valiables
let s:null_pos = [0, 0, 0, 0]

" types
let s:type_list = type([])

" patchs
if v:version > 704 || (v:version == 704 && has('patch237'))
  let s:has_patch_7_4_362 = has('patch-7.4.362')
  let s:has_patch_7_4_392 = has('patch-7.4.392')
else
  let s:has_patch_7_4_362 = v:version == 704 && has('patch362')
  let s:has_patch_7_4_392 = v:version == 704 && has('patch392')
endif

" features
let s:has_gui_running = has('gui_running')
let s:has_window_ID = exists('*win_getid')

" SID
function! s:SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction
let s:SID = printf("\<SNR>%s_", s:SID())
delfunction s:SID
"}}}

function! sandwich#highlight#new() abort  "{{{
  return deepcopy(s:highlight)
endfunction
"}}}

" s:highlight "{{{
let s:highlight = {
      \   'status': 0,
      \   'group' : '',
      \   'id'    : [],
      \   'order_list': [],
      \   'region': {},
      \   'linewise': 0,
      \   'bufnr': 0,
      \   'winid': 0,
      \ }
"}}}
function! s:highlight.initialize() dict abort "{{{
  call self.quench()
  let self.status = 0
  let self.group = ''
  let self.id = []
  let self.order_list = []
  let self.region = {}
  let self.linewise = 0
  let self.bufnr = 0
  let self.winid = 0
endfunction
"}}}
function! s:highlight.order(target, linewise) dict abort  "{{{
  let order = []
  let order_list = []
  for [head, tail, linewise] in [[a:target.head1, a:target.tail1, a:linewise[0]],
                              \  [a:target.head2, a:target.tail2, a:linewise[1]]]
    if linewise
      call s:highlight_order_linewise(order_list, order, head, tail)
    else
      call s:highlight_order_charwise(order_list, order, head, tail)
    endif
  endfor
  if order != []
    call add(order_list, order)
  endif
  let self.order_list += order_list
  let self.region = deepcopy(a:target)
  let self.linewise = a:linewise
endfunction
"}}}
function! s:highlight.show(...) dict abort "{{{
  if self.order_list == []
    return 0
  endif

  if a:0 < 1
    if self.group ==# ''
      return 0
    else
      let hi_group = self.group
    endif
  else
    let hi_group = a:1
  endif

  if self.status
    if hi_group ==# self.group
      return 0
    else
      call self.quench()
    endif
  endif

  for order in self.order_list
    let self.id += s:matchaddpos(hi_group, order)
  endfor
  call filter(self.id, 'v:val > 0')
  let self.status = 1
  let self.group = hi_group
  let self.bufnr = bufnr('%')
  if s:has_window_ID
    let self.winid = win_getid()
  endif
  return 1
endfunction
"}}}
function! s:highlight.quench() dict abort "{{{
  if !self.status
    return 0
  endif

  let tabnr = tabpagenr()
  let winnr = winnr()
  let view = winsaveview()
  if self.highlighted_window()
    call s:matchdelete_all(self.id)
    let self.status = 0
    return 1
  endif

  if s:is_in_cmdline_window() || s:is_in_popup_terminal_window()
    let s:paused += [self]
    augroup sandwich-pause-quenching
      autocmd!
      autocmd WinEnter * call s:got_out_of_cmdwindow()
    augroup END
    return 0
  endif

  if self.goto_highlighted_window()
    call s:matchdelete_all(self.id)
  else
    call filter(self.id, 0)
  endif
  let self.status = 0
  call s:goto_window(winnr, tabnr, view)
  return 1
endfunction
"}}}
function! s:highlight.quench_timer(time) dict abort "{{{
  let id = timer_start(a:time, s:SID . 'quench')
  let s:quench_table[string(id)] = self
  " this is called when user gets control again
  call timer_start(1, {-> s:set_autocmds(id)})
  return id
endfunction
"}}}
" function! s:highlight.highlighted_window() dict abort "{{{
if s:has_window_ID
  function! s:highlight.highlighted_window() dict abort
    return self.winid == win_getid()
  endfunction
else
  function! s:highlight.highlighted_window() dict abort
    if self.id == []
      return 0
    endif

    let id = self.id[0]
    return filter(getmatches(), 'v:val.id == id') != [] ? 1 : 0
  endfunction
endif
"}}}
" function! s:highlight.goto_highlighted_window() dict abort "{{{
if s:has_window_ID
  function! s:highlight.goto_highlighted_window() dict abort
    noautocmd let reached = win_gotoid(self.winid)
    return reached
  endfunction
else
  function! s:highlight.goto_highlighted_window() dict abort
    return s:search_highlighted_windows(self.id, tabpagenr()) != [0, 0]
  endfunction
endif
"}}}

" for delayed quenching "{{{
let s:quench_table = {}
let s:paused = []
function! s:quench(id) abort  "{{{
  let options = s:shift_options()
  let highlight = s:get(a:id)
  try
    if highlight != {}
      call highlight.quench()
    endif
  catch /^Vim\%((\a\+)\)\=:E523/
    " NOTE: For "textlock"
    if highlight != {}
      call highlight.quench_timer(50)
    endif
    return 1
  finally
    unlet s:quench_table[a:id]
    call timer_stop(a:id)
    call s:clear_autocmds()
    call s:restore_options(options)
  endtry
endfunction
"}}}
function! s:get(id) abort "{{{
  return get(s:quench_table, string(a:id), {})
endfunction
"}}}
function! sandwich#highlight#cancel(...) abort "{{{
  if a:0 > 0
    let id_list = type(a:1) == s:type_list ? a:1 : a:000
  else
    let id_list = map(keys(s:quench_table), 'str2nr(v:val)')
  endif

  for id in id_list
    call s:quench(id)
  endfor
endfunction
"}}}
function! s:quench_paused(...) abort "{{{
  if s:is_in_cmdline_window() || s:is_in_popup_terminal_window()
    return
  endif

  augroup sandwich-pause-quenching
    autocmd!
  augroup END

  for highlight in s:paused
    call highlight.quench()
  endfor
  let s:paused = []
endfunction
"}}}
function! s:got_out_of_cmdwindow() abort "{{{
  augroup sandwich-pause-quenching
    autocmd!
    autocmd CursorMoved * call s:quench_paused()
  augroup END
endfunction
"}}}
function! s:set_autocmds(id) abort "{{{
  augroup sandwich-highlight
    autocmd!
    execute printf('autocmd TextChanged,InsertEnter,BufUnload <buffer> call s:cancel_highlight(%s)', a:id)
    execute printf('autocmd BufEnter * call s:switch_highlight(%s)', a:id)
  augroup END
endfunction
"}}}
function! s:clear_autocmds() abort "{{{
  augroup sandwich-highlight
    autocmd!
  augroup END
endfunction
"}}}
function! s:cancel_highlight(id) abort  "{{{
  call s:quench(a:id)
endfunction
"}}}
function! s:switch_highlight(id) abort "{{{
  let highlight = s:get(a:id)
  if highlight == {} || !highlight.highlighted_window()
    return
  endif

  if highlight.bufnr == bufnr('%')
    call highlight.show()
  else
    call highlight.quench()
  endif
endfunction
"}}}
"}}}

" private functions
function! s:highlight_order_charwise(order_list, order, head, tail) abort  "{{{
  let n = len(a:order)
  if a:head != s:null_pos && a:tail != s:null_pos && s:is_equal_or_ahead(a:tail, a:head)
    if a:head[1] == a:tail[1]
      call add(a:order, a:head[1:2] + [a:tail[2] - a:head[2] + 1])
      let n += 1
    else
      for lnum in range(a:head[1], a:tail[1])
        if lnum == a:head[1]
          call add(a:order, a:head[1:2] + [col([a:head[1], '$']) - a:head[2] + 1])
        elseif lnum == a:tail[1]
          call add(a:order, [a:tail[1], 1] + [a:tail[2]])
        else
          call add(a:order, [lnum])
        endif

        if n == 7
          call add(a:order_list, deepcopy(a:order))
          call filter(a:order, 0)
          let n = 0
        else
          let n += 1
        endif
      endfor
    endif
  endif
endfunction
"}}}
function! s:highlight_order_linewise(order_list, order, head, tail) abort  "{{{
  let n = len(a:order)
  if a:head != s:null_pos && a:tail != s:null_pos && a:head[1] <= a:tail[1]
    for lnum in range(a:head[1], a:tail[1])
      call add(a:order, [lnum])
      if n == 7
        call add(a:order_list, deepcopy(a:order))
        call filter(a:order, 0)
        let n = 0
      else
        let n += 1
      endif
    endfor
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
function! s:matchdelete_all(ids) abort "{{{
  if empty(a:ids)
    return
  endif

  let alive_ids = map(getmatches(), 'v:val.id')
  " Return if another plugin called clearmatches() which clears *ALL*
  " highlights including others set.
  if empty(alive_ids)
    return
  endif
  if !count(alive_ids, a:ids[0])
    return
  endif

  for id in a:ids
    try
      call matchdelete(id)
    catch
    endtry
  endfor
  call filter(a:ids, 0)
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
" function! s:is_in_cmdline_window() abort  "{{{
if s:has_patch_7_4_392
  function! s:is_in_cmdline_window() abort
    return getcmdwintype() !=# ''
  endfunction
else
  function! s:is_in_cmdline_window() abort
    let is_in_cmdline_window = 0
    try
      execute 'tabnext ' . tabpagenr()
    catch /^Vim\%((\a\+)\)\=:E11/
      let is_in_cmdline_window = 1
    catch
    finally
      return is_in_cmdline_window
    endtry
  endfunction
endif
"}}}
" function! s:is_in_popup_terminal_window() abort  "{{{
if exists('*popup_list')
  function! s:is_in_popup_terminal_window() abort
    return &buftype is# 'terminal' && count(popup_list(), win_getid())
  endfunction
else
  function! s:is_in_popup_terminal_window() abort
    return 0
  endfunction
endif
" }}}
function! s:shift_options() abort "{{{
  let options = {}

  """ tweak appearance
  " hide_cursor
  if s:has_gui_running
    let options.cursor = &guicursor
    set guicursor+=a:block-NONE
  else
    let options.cursor = &t_ve
    set t_ve=
  endif

  return options
endfunction
"}}}
function! s:restore_options(options) abort "{{{
  if s:has_gui_running
    set guicursor&
    let &guicursor = a:options.cursor
  else
    let &t_ve = a:options.cursor
  endif
endfunction
"}}}
function! s:search_highlighted_windows(id, ...) abort  "{{{
  if a:id == []
    return 0
  endif

  let original_winnr = winnr()
  let original_tabnr = tabpagenr()
  let original_view = winsaveview()
  let tablist = range(1, tabpagenr('$'))
  if a:0 > 0
    let tabnr = a:1
    let [tabnr, winnr] = s:scan_windows(a:id, tabnr)
    if tabnr != 0
      return [tabnr, winnr]
    endif
    call filter(tablist, 'v:val != tabnr')
  endif

  for tabnr in tablist
    let [tabnr, winnr] = s:scan_windows(a:id, tabnr)
    if tabnr != 0
      return [tabnr, winnr]
    endif
  endfor
  call s:goto_window(original_winnr, original_tabnr, original_view)
  return [0, 0]
endfunction
"}}}
function! s:scan_windows(id, tabnr) abort "{{{
  if s:goto_tab(a:tabnr)
    for winnr in range(1, winnr('$'))
      if s:goto_window(winnr) && s:is_highlighted_window(a:id)
        return [a:tabnr, winnr]
      endif
    endfor
  endif
  return [0, 0]
endfunction
"}}}
function! s:is_highlighted_window(id) abort "{{{
  if a:id != []
    let id = a:id[0]
    if filter(getmatches(), 'v:val.id == id') != []
      return 1
    endif
  endif
  return 0
endfunction
"}}}
function! s:goto_window(winnr, ...) abort "{{{
  if a:0 > 0
    if !s:goto_tab(a:1)
      return 0
    endif
  endif


  try
    if a:winnr != winnr()
      execute printf('noautocmd %swincmd w', a:winnr)
    endif
  catch /^Vim\%((\a\+)\)\=:E16/
    return 0
  endtry

  if a:0 > 1
    noautocmd call winrestview(a:2)
  endif

  return 1
endfunction
"}}}
function! s:goto_tab(tabnr) abort  "{{{
  if a:tabnr != tabpagenr()
    execute 'noautocmd tabnext ' . a:tabnr
  endif
  return tabpagenr() == a:tabnr ? 1 : 0
endfunction
"}}}


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
