" common functions

" variables "{{{
" null valiables
let s:null_pos   = [0, 0, 0, 0]
"}}}

function! operator#sandwich#lib#funcref(list) abort "{{{
  return map(copy(a:list), 'function("s:" . v:val)')
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

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
