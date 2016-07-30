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
      \   'linewise': '',
      \   'bufnr': 0,
      \   'text': ''
      \ }
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
  let self.text = s:get_surround_text(self.region, self.linewise)
endfunction
"}}}
function! s:highlight.show(hi_group) dict abort "{{{
  if self.order_list == []
    return 0
  endif

  if self.status && a:hi_group !=# self.group
    call self.quench()
  endif

  if self.status
    return 0
  endif

  for order in self.order_list
    let self.id += s:matchaddpos(a:hi_group, order)
  endfor
  call filter(self.id, 'v:val > 0')
  let self.status = 1
  let self.group = a:hi_group
  let self.bufnr = bufnr('%')
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
  if s:is_highlight_exists(self.id)
    call map(self.id, 'matchdelete(v:val)')
    call filter(self.id, 'v:val > 0')
    let succeeded = 1
  else
    if s:is_in_cmdline_window()
      let s:quenching_queue += [self]
      augroup sandwich-quech-queue
        autocmd!
        autocmd CmdWinLeave * call s:exodus_from_cmdwindow()
      augroup END
      let succeeded = 0
    else
      if s:search_highlighted_windows(self.id, tabnr) != [0, 0]
        call map(self.id, 'matchdelete(v:val)')
        call filter(self.id, 'v:val > 0')
        let succeeded = 1
      else
        call filter(self.id, 0)
        let succeeded = 0
      endif
      call s:goto_window(winnr, tabnr, view)
    endif
  endif

  if succeeded
    let self.status = 0
    let self.group = ''
  endif
  return succeeded
endfunction
"}}}
function! s:highlight.scheduled_quench(time, ...) dict abort  "{{{
  let id = get(a:000, 0, -1)
  if id < 0
    let id = timer_start(a:time, s:SID . 'scheduled_quench')
  endif

  if !has_key(s:quench_table, id)
    let s:quench_table[id] = []
  endif
  let s:quench_table[id] += [self]
  return id
endfunction
"}}}
function! s:highlight.is_text_identical() dict abort "{{{
  return s:get_surround_text(self.region, self.linewise) ==# self.text
endfunction
"}}}

" for scheduled-quench "{{{
let s:quench_table = {}
function! s:scheduled_quench(id) abort  "{{{
  let options = s:shift_options()
  try
    for highlight in get(s:quench_table, a:id, [])
      call highlight.quench()
    endfor
    redraw
    execute 'augroup sandwich-highlight-cancel-' . a:id
      autocmd!
    augroup END
    execute 'augroup! sandwich-highlight-cancel-' . a:id
    unlet s:quench_table[a:id]
  finally
    call s:restore_options(options)
  endtry
endfunction
"}}}
function! sandwich#highlight#cancel(...) abort "{{{
  if a:0 > 0
    let id_list = type(a:1) == s:type_list ? a:1 : a:000
  else
    let id_list = map(keys(s:quench_table), 'str2nr(v:val)')
  endif

  for id in id_list
    call s:scheduled_quench(id)
    call timer_stop(id)
  endfor
endfunction
"}}}
function! sandwich#highlight#get(id) abort "{{{
  return get(s:quench_table, a:id, [])
endfunction
"}}}
let s:quenching_queue = []
function! s:quench_queued(...) abort "{{{
  if s:is_in_cmdline_window()
    return
  endif

  augroup sandwich-quech-queue
    autocmd!
  augroup END

  let list = copy(s:quenching_queue)
  let s:quenching_queue = []
  for highlight in list
    call highlight.quench()
  endfor
endfunction
"}}}
function! s:exodus_from_cmdwindow() abort "{{{
  augroup sandwich-quech-queue
    autocmd!
    autocmd CursorMoved * call s:quench_queued()
  augroup END
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
function! s:is_equal_or_ahead(pos1, pos2) abort  "{{{
  return a:pos1[1] > a:pos2[1] || (a:pos1[1] == a:pos2[1] && a:pos1[2] >= a:pos2[2])
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
      execute a:winnr . 'wincmd w'
    endif
  catch /^Vim\%((\a\+)\)\=:E16/
    return 0
  endtry

  if a:0 > 1
    call winrestview(a:2)
  endif

  return 1
endfunction
"}}}
function! s:goto_tab(tabnr) abort  "{{{
  if a:tabnr != tabpagenr()
    execute 'tabnext ' . a:tabnr
  endif
  return tabpagenr() == a:tabnr ? 1 : 0
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
  let original_winnr = winnr()
  let original_tabnr = tabpagenr()
  if a:id != []
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
  endif
  execute 'tabnext ' . original_tabnr
  execute original_winnr . 'wincmd w'
  return [0, 0]
endfunction
"}}}
function! s:scan_windows(id, tabnr) abort "{{{
  if s:goto_tab(a:tabnr)
    for winnr in range(1, winnr('$'))
      if s:goto_window(winnr) && s:is_highlight_exists(a:id)
        return [a:tabnr, winnr]
      endif
    endfor
  endif
  return [0, 0]
endfunction
"}}}
function! s:is_highlight_exists(id) abort "{{{
  if a:id != []
    let id = a:id[0]
    if filter(getmatches(), 'v:val.id == id') != []
      return 1
    endif
  endif
  return 0
endfunction
"}}}
function! s:get_surround_text(region, linewise) abort  "{{{
  let head = a:region.head1
  if a:linewise[0]
    let head[2] = 1
  endif

  if a:region.tail2 == s:null_pos
    let tail = a:region.tail1
  else
    let tail = a:region.tail2
  endif
  if a:linewise[1]
    let tail[2] = col([tail[1], '$']) - 1
  endif
  return s:get_buf_text(head, tail)
endfunction
"}}}
function! s:get_buf_text(head, tail) abort  "{{{
  let endline = line('$')
  if a:head == s:null_pos || a:tail == s:null_pos || s:is_ahead(a:head, a:tail) || a:head[1] > endline || a:tail[1] > endline
    return ''
  endif

  let lines = getline(a:head[1], a:tail[1])
  if a:head[1] == a:tail[1]
    let lines[0] = lines[0][a:head[2]-1 : a:tail[2]-1]
  else
    let lines[0] = lines[0][a:head[2]-1 :]
    let lines[-1] = lines[-1][: a:tail[2]-1]
  endif
  return join(lines, "\n")
endfunction
"}}}
function! s:is_ahead(pos1, pos2) abort  "{{{
  return a:pos1[1] > a:pos2[1] || (a:pos1[1] == a:pos2[1] && a:pos1[2] > a:pos2[2])
endfunction
"}}}


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
