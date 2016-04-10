" message object - managing messages and errors.

function! sandwich#message#new() abort  "{{{
  return deepcopy(s:message)
endfunction
"}}}

" s:message "{{{
let s:message = {
      \   'error' : {'flag': 0, 'string': ''},
      \   'notice': {'flag': 0, 'list': []},
      \ }
"}}}
function! s:message.initialize() dict abort  "{{{
  let self.error.flag   = 0
  let self.error.string = ''
  let self.notice.flag  = 0
  let self.notice.list  = []
endfunction
"}}}
function! s:message.notify(prefix) dict abort "{{{
  if self.error.flag
    call self.error.echoerr(a:prefix)
  elseif self.notice.flag
    call self.notice.echo(a:prefix)
  endif
endfunction
"}}}
function! s:message.error.echoerr(prefix) dict abort  "{{{
  echoerr a:prefix . self.string
endfunction
"}}}
function! s:message.notice.echo(prefix) dict abort "{{{
  let queue = []
  if self.list != []
    for line in self.list
      let queue += [[a:prefix, 'MoreMsg']]
      let queue += [line]
      let queue += [["\n", 'NONE']]
    endfor
    call remove(queue, -1)
  endif
  call sandwich#util#echo(queue)
endfunction
"}}}
function! s:message.error.set(errmes) dict abort  "{{{
  let self.flag = 1
  let self.string = a:errmes
endfunction
"}}}
function! s:message.notice.queue(line) dict abort "{{{
  let self.flag = 1
  call add(self.list, a:line)
endfunction
"}}}


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
