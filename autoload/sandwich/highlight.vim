" highlight object - managing highlight on a buffer

" variables "{{{
" null valiables
let s:null_pos = [0, 0, 0, 0]

" types
let s:type_list = type([])

" patchs
if v:version > 704 || (v:version == 704 && has('patch237'))
  let s:has_patch_7_4_362 = has('patch-7.4.362')
else
  let s:has_patch_7_4_362 = v:version == 704 && has('patch362')
endif

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
  let self.status = 1
  let self.group = a:hi_group
  call filter(self.id, 'v:val > 0')
  return 1
endfunction
"}}}
function! s:highlight.quench() dict abort "{{{
  if !self.status
    return 0
  endif

  call map(self.id, 'matchdelete(v:val)')
  call filter(self.id, 'v:val > 0')
  let self.status = 0
  let self.group = ''
  return 1
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

" for scheduled-quench "{{{
let s:quench_table = {}
function! s:scheduled_quench(id) abort  "{{{
  for highlight in s:quench_table[a:id]
    call highlight.quench()
  endfor
  augroup sandwich-highlight-cancel
    autocmd!
  augroup END
  unlet s:quench_table[a:id]
endfunction
"}}}
function! sandwich#highlight#cancel(id) abort "{{{
  call s:scheduled_quench(a:id)
  call timer_stop(a:id)
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


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
