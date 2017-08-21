if has('win16') || has('win32') || has('win64') || has('win95')
  set shellslash
endif
execute 'set runtimepath+=' . expand('<sfile>:p:h:h:h')
source <sfile>:p:h:h:h/plugin/operator/sandwich.vim
source <sfile>:p:h:h:h/plugin/textobj/sandwich.vim
source <sfile>:p:h:h:h/plugin/sandwich.vim
nnoremap <Plug>(test-dot) .
let g:operator_sandwich_no_visualrepeat = 1

function! s:assert(a1, a2, kind) abort
  if type(a:a1) == type(a:a2) && string(a:a1) ==# string(a:a2)
    return
  endif

  %delete
  call append(0, ['Got:', string(a:a1)])
  call append(0, [printf('Failured at "%s"', a:kind), '', 'Expect:', string(a:a2)])
  $delete
  1,$print
  cquit
endfunction

function! s:quit_by_error() abort
  %delete
  call append(0, [printf('Catched the following error at %s.', v:throwpoint), v:exception])
  $delete
  1,$print
  cquit
endfunction

function! Count(...) abort
  let s:count += 1
  return s:count
endfunction

function! ListCount(...) abort
  let s:count += 1
  return [s:count, s:count]
endfunction



try

""" operator-add
" normal use
call setline('.', 'foo')
normal saiw(
normal .
call s:assert(getline('.'), '((foo))', 'operator-add:normal use #1')
call s:assert(getpos('.'), [0, 1, 3, 0], 'operator-add:normal use #2')

normal saiw[
normal .
call s:assert(getline('.'), '(([[foo]]))', 'operator-add:normal use #3')
call s:assert(getpos('.'), [0, 1, 5, 0], 'operator-add:normal use #4')

%delete

" blockwise-visual
call append(0, ['foo', 'bar', 'baz'])
$delete
execute "normal gg\<C-v>2j2lsa("
normal .
call s:assert(getline(1), '((foo))', 'operator-add:blockwise-visual #1')
call s:assert(getline(2), '((bar))', 'operator-add:blockwise-visual #2')
call s:assert(getline(3), '((baz))', 'operator-add:blockwise-visual #3')
call s:assert(getpos('.'), [0, 1, 3, 0], 'operator-add:blockwise-visual #4')

normal j.
call s:assert(getline(1), '((foo))', 'operator-add:blockwise-visual #5')
call s:assert(getline(2), '(((bar)))', 'operator-add:blockwise-visual #6')
call s:assert(getline(3), '(((baz)))', 'operator-add:blockwise-visual #7')
call s:assert(getpos('.'), [0, 2, 4, 0], 'operator-add:blockwise-visual #8')

normal j.
call s:assert(getline(1), '((foo))', 'operator-add:blockwise-visual #9')
call s:assert(getline(2), '(((bar)))', 'operator-add:blockwise-visual #10')
call s:assert(getline(3), '((((baz))))', 'operator-add:blockwise-visual #11')
call s:assert(getpos('.'), [0, 3, 5, 0], 'operator-add:blockwise-visual #12')

%delete

" count
call setline('.', 'foo')
normal 2saiw((
normal .
call s:assert(getline('.'), '((((foo))))', 'operator-add:count #1')
call s:assert(getpos('.'), [0, 1, 5, 0], 'operator-add:count #2')

call setline('.', 'foo')
normal saiw(
call setline('.', 'foo bar')
normal 3.
call s:assert(getline('.'), '(foo bar)', 'operator-add:count #3')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-add:count #4')

%delete

" expr
let g:sandwich#recipes = []
let g:operator#sandwich#recipes = [{'buns': ['Count()', 'Count()'], 'expr': 1, 'input': ['c']}]
call setline('.', 'foo')
let s:count = 0
normal saiwc
normal .
call s:assert(getline('.'), '11foo22', 'operator-add:expr #1')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-add:expr #2')

let g:operator#sandwich#recipes = [{'buns': ['Count()', 'Count()'], 'expr': 2, 'input': ['c']}]
call setline('.', 'foo')
let s:count = 0
normal saiwc
normal .
call s:assert(getline('.'), '31foo24', 'operator-add:expr #3')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-add:expr #4')

unlet g:sandwich#recipes
unlet g:operator#sandwich#recipes
%delete

" listexpr
let g:sandwich#recipes = []
let g:operator#sandwich#recipes = [{'buns': 'ListCount()', 'listexpr': 1, 'input': ['c']}]
call setline('.', 'foo')
let s:count = 0
normal saiwc
normal .
call s:assert(getline('.'), '11foo11', 'operator-add:listexpr #1')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-add:listexpr #2')

let g:operator#sandwich#recipes = [{'buns': 'ListCount()', 'listexpr': 2, 'input': ['c']}]
call setline('.', 'foo')
let s:count = 0
normal saiwc
normal .
call s:assert(getline('.'), '21foo12', 'operator-add:listexpr #3')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-add:listexpr #4')

unlet g:sandwich#recipes
unlet g:operator#sandwich#recipes
%delete

" cursor option 'keep'
call operator#sandwich#set('add', 'all', 'cursor', 'keep')
nmap . <Plug>(operator-sandwich-dot)
call setline('.', 'foo')
normal 0lsaiw(
normal .
call s:assert(getline('.'), '((foo))', 'operator-add:cursor keep #1')
call s:assert(getpos('.'), [0, 1, 4, 0], 'operator-add:cursor keep #2')

call setline('.', 'foo')
normal 0lsaiw(
call setline('.', 'foo bar')
normal 0l3.
call s:assert(getline('.'), '(foo bar)', 'operator-add:cursor keep #3')
call s:assert(getpos('.'), [0, 1, 3, 0], 'operator-add:cursor keep #4')

nmap . <Plug>(operator-sandwich-predot)<Plug>(test-dot)
call setline('.', 'foo')
normal 0lsaiw(
normal .
call s:assert(getline('.'), '((foo))', 'operator-add:cursor keep #5')
call s:assert(getpos('.'), [0, 1, 4, 0], 'operator-add:cursor keep #6')

call setline('.', 'foo')
normal 0lsaiw(
call setline('.', 'foo bar')
normal 0l3.
call s:assert(getline('.'), '(foo bar)', 'operator-add:cursor keep #7')
call s:assert(getpos('.'), [0, 1, 3, 0], 'operator-add:cursor keep #8')

call operator#sandwich#set_default()
nunmap .
%delete



""" operator-delete
nmap sd <Plug>(operator-sandwich-delete)
xmap sd <Plug>(operator-sandwich-delete)
" normal use
call setline('.', '((foo))')
normal sda(
normal .
call s:assert(getline('.'), 'foo', 'operator-delete:normal use #1')
call s:assert(getpos('.'), [0, 1, 1, 0], 'operator-delete:normal use #2')

call setline('.', '[[foo]]')
normal sda[
normal .
call s:assert(getline('.'), 'foo', 'operator-delete:normal use #3')
call s:assert(getpos('.'), [0, 1, 1, 0], 'operator-delete:normal use #4')

%delete

" blockwise-visual
call append(0, ['(((((foo)))))', '(((((bar)))))', '(((((baz)))))'])
$delete
execute "normal ggffh\<C-v>2j4lsd"
normal h.
call s:assert(getline(1), '(((foo)))', 'operator-delete:blockwise-visual #1')
call s:assert(getline(2), '(((bar)))', 'operator-delete:blockwise-visual #2')
call s:assert(getline(3), '(((baz)))', 'operator-delete:blockwise-visual #3')
call s:assert(getpos('.'), [0, 1, 4, 0], 'operator-delete:blockwise-visual #4')

normal jh.
call s:assert(getline(1), '(((foo)))', 'operator-delete:blockwise-visual #5')
call s:assert(getline(2), '((bar))', 'operator-delete:blockwise-visual #6')
call s:assert(getline(3), '((baz))', 'operator-delete:blockwise-visual #7')
call s:assert(getpos('.'), [0, 2, 3, 0], 'operator-delete:blockwise-visual #8')

normal jh.
call s:assert(getline(1), '(((foo)))', 'operator-delete:blockwise-visual #9')
call s:assert(getline(2), '((bar))', 'operator-delete:blockwise-visual #10')
call s:assert(getline(3), '(baz)', 'operator-delete:blockwise-visual #11')
call s:assert(getpos('.'), [0, 3, 2, 0], 'operator-delete:blockwise-visual #12')

%delete

" count
call setline('.', '((((foo))))')
normal 02sda(
normal .
call s:assert(getline('.'), 'foo', 'operator-delete:count #1')
call s:assert(getpos('.'), [0, 1, 1, 0], 'operator-delete:count #2')

call setline('.', '[([[foo]])]')
normal ffsda[
normal 2.
call s:assert(getline('.'), '([foo])', 'operator-delete:count #3')
call s:assert(getpos('.'), [0, 1, 1, 0], 'operator-delete:count #4')

%delete

" external textobjct
let g:sandwich#recipes = []
let g:operator#sandwich#recipes = [{'external': ['it', 'at'], 'noremap': 1}]
call append(0, ['<title>fooo</title>', '<body>bar</body>'])
normal ggsdat
normal j.
call s:assert(getline(1), 'fooo', 'operator-delete:external textobject #1')
call s:assert(getline(2), 'bar', 'operator-delete:external textobject #2')
call s:assert(getpos('.'), [0, 2, 1, 0], 'operator-delete:external textobject #3')

unlet g:sandwich#recipes
unlet g:operator#sandwich#recipes
%delete

" cursor option 'keep'
call operator#sandwich#set('delete', 'all', 'cursor', 'keep')
nmap . <Plug>(operator-sandwich-dot)
call setline('.', '((foo))')
normal 03lsda(
normal .
call s:assert(getline('.'), 'foo', 'operator-delete:cursor keep #1')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-delete:cursor keep #2')

call setline('.', '(foo)')
normal 0sda(
call setline('.', '((foo) bar)')
normal 03l2.
call s:assert(getline('.'), '(foo) bar', 'operator-delete:cursor keep #3')
call s:assert(getpos('.'), [0, 1, 3, 0], 'operator-delete:cursor keep #4')

nmap . <Plug>(operator-sandwich-predot)<Plug>(test-dot)
call setline('.', '((foo))')
normal 03lsda(
normal .
call s:assert(getline('.'), 'foo', 'operator-delete:cursor keep #5')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-delete:cursor keep #6')

call setline('.', '(foo)')
normal 0sda(
call setline('.', '((foo) bar)')
normal 03l2.
call s:assert(getline('.'), '(foo) bar', 'operator-delete:cursor keep #7')
call s:assert(getpos('.'), [0, 1, 3, 0], 'operator-delete:cursor keep #8')

call operator#sandwich#set_default()
nunmap .
%delete



""" operator-replace
nmap sr <Plug>(operator-sandwich-replace)
xmap sr <Plug>(operator-sandwich-replace)
" normal use
call setline('.', '((foo))')
normal 0ffsra([
normal .
call s:assert(getline('.'), '[[foo]]', 'operator-replace:normal use #1')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-replace:normal use #2')

normal 0ffsra[(
normal .
call s:assert(getline('.'), '((foo))', 'operator-replace:normal use #3')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-replace:normal use #4')

%delete

" blockwise-visual
call append(0, ['(foo)', '(bar)', '(baz)'])
$delete
execute "normal gg\<C-v>2j4lsr["
call setline(1, '(foo)')
call setline(2, '(bar)')
call setline(3, '(baz)')
normal h.
call s:assert(getline(1), '[foo]', 'operator-replace:blockwise-visual #1')
call s:assert(getline(2), '[bar]', 'operator-replace:blockwise-visual #2')
call s:assert(getline(3), '[baz]', 'operator-replace:blockwise-visual #3')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-replace:blockwise-visual #4')

call setline(1, '(foo)')
call setline(2, '(bar)')
call setline(3, '(baz)')
normal jh.
call s:assert(getline(1), '(foo)', 'operator-replace:blockwise-visual #5')
call s:assert(getline(2), '[bar]', 'operator-replace:blockwise-visual #6')
call s:assert(getline(3), '[baz]', 'operator-replace:blockwise-visual #7')
call s:assert(getpos('.'), [0, 2, 2, 0], 'operator-replace:blockwise-visual #8')

call setline(1, '(foo)')
call setline(2, '(bar)')
call setline(3, '(baz)')
normal jh.
call s:assert(getline(1), '(foo)', 'operator-replace:blockwise-visual #9')
call s:assert(getline(2), '(bar)', 'operator-replace:blockwise-visual #10')
call s:assert(getline(3), '[baz]', 'operator-replace:blockwise-visual #11')
call s:assert(getpos('.'), [0, 3, 2, 0], 'operator-replace:blockwise-visual #12')

%delete

" count
call setline('.', '((((foo))))')
normal 0ff2sr2a([[
normal .
call s:assert(getline('.'), '[[[[foo]]]]', 'operator-replace:count #1')
call s:assert(getpos('.'), [0, 1, 3, 0], 'operator-replace:count #2')

call setline('.', '[([[foo]])]')
normal 0ffsra[(
normal 2.
call s:assert(getline('.'), '(([(foo)]))', 'operator-replace:count #3')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-replace:count #2')

%delete

" expr
let g:sandwich#recipes = []
let g:operator#sandwich#recipes = [{'buns': ['Count()', 'Count()'], 'expr': 1, 'input': ['c']}, {'buns': ['(', ')']}]
call setline('.', '((foo))')
let s:count = 0
normal ffsra(c
normal .
call s:assert(getline('.'), '11foo22', 'operator-replace:expr #1')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-replace:expr #2')

let g:operator#sandwich#recipes = [{'buns': ['Count()', 'Count()'], 'expr': 2, 'input': ['c']}, {'buns': ['(', ')']}]
call setline('.', '((foo))')
let s:count = 0
normal ffsra(c
normal .
call s:assert(getline('.'), '31foo24', 'operator-replace:expr #3')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-replace:expr #4')

unlet g:sandwich#recipes
unlet g:operator#sandwich#recipes
%delete

" listexpr
let g:sandwich#recipes = []
let g:operator#sandwich#recipes = [{'buns': 'ListCount()', 'listexpr': 1, 'input': ['c']}, {'buns': ['(', ')']}]
call setline('.', '((foo))')
let s:count = 0
normal ffsra(c
normal .
call s:assert(getline('.'), '11foo11', 'operator-replace:listexpr #1')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-replace:listexpr #2')

let g:operator#sandwich#recipes = [{'buns': 'ListCount()', 'listexpr': 2, 'input': ['c']}, {'buns': ['(', ')']}]
call setline('.', '((foo))')
let s:count = 0
normal ffsra(c
normal .
call s:assert(getline('.'), '21foo12', 'operator-replace:listexpr #3')
call s:assert(getpos('.'), [0, 1, 2, 0], 'operator-replace:listexpr #4')

unlet g:sandwich#recipes
unlet g:operator#sandwich#recipes
%delete

" external textobjct
let g:sandwich#recipes = []
let g:operator#sandwich#recipes = [{'external': ['it', 'at'], 'noremap': 1}, {'buns': ['(', ')']}]
call append(0, ['<title>fooo</title>', '<body>bar</body>'])
normal ggsrat(
normal j.
call s:assert(getline(1), '(fooo)', 'operator-replace:external textobject #1')
call s:assert(getline(2), '(bar)', 'operator-replace:external textobject #2')
call s:assert(getpos('.'), [0, 2, 2, 0], 'operator-replace:external textobject #3')

unlet g:sandwich#recipes
unlet g:operator#sandwich#recipes
%delete

" cursor option 'keep'
call operator#sandwich#set('replace', 'all', 'cursor', 'keep')
nmap . <Plug>(operator-sandwich-dot)
call setline('.', '((foo))')
normal 03lsra([
normal .
call s:assert(getline('.'), '[[foo]]', 'operator-delete:cursor keep #1')
call s:assert(getpos('.'), [0, 1, 4, 0], 'operator-delete:cursor keep #2')

call setline('.', '(foo)')
normal 0sra([
call setline('.', '((foo) bar)')
normal 03l2.
call s:assert(getline('.'), '[(foo) bar]', 'operator-delete:cursor keep #3')
call s:assert(getpos('.'), [0, 1, 4, 0], 'operator-delete:cursor keep #4')

nmap . <Plug>(operator-sandwich-predot)<Plug>(test-dot)
call setline('.', '((foo))')
normal 03lsra([
normal .
call s:assert(getline('.'), '[[foo]]', 'operator-delete:cursor keep #5')
call s:assert(getpos('.'), [0, 1, 4, 0], 'operator-delete:cursor keep #6')

call setline('.', '(foo)')
normal 0sra([
call setline('.', '((foo) bar)')
normal 03l2.
call s:assert(getline('.'), '[(foo) bar]', 'operator-delete:cursor keep #7')
call s:assert(getpos('.'), [0, 1, 4, 0], 'operator-delete:cursor keep #8')

call operator#sandwich#set_default()
nunmap .
%delete



""" textobj-query
" normal use
call setline('.', '(foo)')
normal dis(
call setline('.', '(foo)')
normal .
call s:assert(getline('.'), '()', 'textobj-query:normal use #1')

call setline('.', '(foo)')
normal das(
call setline('.', '(foo)')
normal .
call s:assert(getline('.'), '', 'textobj-query:normal use #2')

%delete

" count
call setline('.', '((foo))((bar))')
normal 0ffdis(
normal 0fb2.
call s:assert(getline('.'), '(())()', 'textobj-query:count #1')

call setline('.', '((foo))((bar))')
normal 0ffdas(
normal 0fb2.
call s:assert(getline('.'), '()', 'textobj-query:count #2')

%delete

" expr
let g:sandwich#recipes = []
let g:textobj#sandwich#recipes = [{'buns': ['Count()', 'Count()'], 'expr': 1, 'input': ['c']}]
call setline('.', '1foo2')
let s:count = 0
normal disc
call setline('.', '1foo2')
normal .
call s:assert(getline('.'), '12', 'textobj-query:expr #1')

call setline('.', '1foo2')
let s:count = 0
normal dasc
call setline('.', '1foo2')
normal .
call s:assert(getline('.'), '', 'textobj-query:expr #2')

let g:sandwich#recipes = []
let g:textobj#sandwich#recipes = [{'buns': ['Count()', 'Count()'], 'expr': 2, 'input': ['c']}]
call setline('.', '1foo2')
let s:count = 0
normal disc
call setline('.', '3foo4')
normal .
call s:assert(getline('.'), '34', 'textobj-query:expr #3')

call setline('.', '1foo2')
let s:count = 0
normal dasc
call setline('.', '3foo4')
normal .
call s:assert(getline('.'), '', 'textobj-query:expr #4')

unlet g:sandwich#recipes
unlet g:textobj#sandwich#recipes
%delete

" listexpr
let g:sandwich#recipes = []
let g:textobj#sandwich#recipes = [{'buns': 'ListCount()', 'listexpr': 1, 'input': ['c']}]
call setline('.', '1foo1')
let s:count = 0
normal disc
call setline('.', '1foo1')
normal .
call s:assert(getline('.'), '11', 'textobj-query:listexpr #1')

call setline('.', '1foo1')
let s:count = 0
normal dasc
call setline('.', '1foo1')
normal .
call s:assert(getline('.'), '', 'textobj-query:listexpr #2')

let g:sandwich#recipes = []
let g:textobj#sandwich#recipes = [{'buns': 'ListCount()', 'listexpr': 2, 'input': ['c']}]
call setline('.', '1foo1')
let s:count = 0
normal disc
call setline('.', '2foo2')
normal .
call s:assert(getline('.'), '22', 'textobj-query:listexpr #3')

call setline('.', '1foo1')
let s:count = 0
normal dasc
call setline('.', '2foo2')
normal .
call s:assert(getline('.'), '', 'textobj-query:listexpr #4')

unlet g:sandwich#recipes
unlet g:textobj#sandwich#recipes
%delete

" external textobjct
let g:sandwich#recipes = []
let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'noremap': 1, 'input': ['t']}]
call append(0, ['<title>fooo</title>', '<body>bar</body>'])
$delete
normal ggdist
normal j.
call s:assert(getline(1), '<title></title>', 'textobj-query:external textobject #1')
call s:assert(getline(2), '<body></body>', 'textobj-query:external textobject #2')

%delete

call append(0, ['<title>fooo</title>', '<body>bar</body>'])
$delete
normal ggdast
normal j.
call s:assert(getline(1), '', 'textobj-query:external textobject #3')
call s:assert(getline(2), '', 'textobj-query:external textobject #4')

unlet g:sandwich#recipes
unlet g:textobj#sandwich#recipes
%delete

" synchro option
let g:sandwich#recipes = []
let g:textobj#sandwich#recipes = [{'buns': ['foo', 'baz'], 'synchro': 1, 'input': ['f']}]
call append(0, ['foo bar baz', ' foo baaaaar baz'])
$delete
normal ggdisf
normal jl.
call s:assert(getline(1), 'foobaz', 'textobj-query: synchro option #1')
call s:assert(getline(2), ' foobaz', 'textobj-query: synchro option #2')

%delete

call append(0, ['foo bar baz', ' foo baaaaar baz'])
$delete
normal ggdasf
normal jl.
call s:assert(getline(1), '', 'textobj-query: synchro option #3')
call s:assert(getline(2), ' ', 'textobj-query: synchro option #4')

unlet g:sandwich#recipes
unlet g:textobj#sandwich#recipes
%delete



""" textobj-auto
" normal use
call setline('.', '(foo)')
normal dib
call setline('.', '(foo)')
normal .
call s:assert(getline('.'), '()', 'textobj-auto:normal use #1')

call setline('.', '(foo)')
normal dab
call setline('.', '(foo)')
normal .
call s:assert(getline('.'), '', 'textobj-auto:normal use #2')

%delete

" count
call setline('.', '((foo))((bar))')
normal 0ffdib
normal 0fb2.
call s:assert(getline('.'), '(())()', 'textobj-auto:count #1')

call setline('.', '((foo))((bar))')
normal 0ffdab
normal 0fb2.
call s:assert(getline('.'), '()', 'textobj-auto:count #2')

%delete

" expr
let g:sandwich#recipes = []
let g:textobj#sandwich#recipes = [{'buns': ['Count()', 'Count()'], 'expr': 1, 'input': ['c']}]
call setline('.', '1foo2')
let s:count = 0
normal dib
call setline('.', '1foo2')
normal .
call s:assert(getline('.'), '12', 'textobj-auto:expr #1')

call setline('.', '1foo2')
let s:count = 0
normal dab
call setline('.', '1foo2')
normal .
call s:assert(getline('.'), '', 'textobj-auto:expr #2')

let g:sandwich#recipes = []
let g:textobj#sandwich#recipes = [{'buns': ['Count()', 'Count()'], 'expr': 2, 'input': ['c']}]
call setline('.', '1foo2')
let s:count = 0
normal dib
call setline('.', '3foo4')
normal .
call s:assert(getline('.'), '34', 'textobj-auto:expr #3')

call setline('.', '1foo2')
let s:count = 0
normal dab
call setline('.', '3foo4')
normal .
call s:assert(getline('.'), '', 'textobj-auto:expr #4')

unlet g:sandwich#recipes
unlet g:textobj#sandwich#recipes
%delete

" listexpr
let g:sandwich#recipes = []
let g:textobj#sandwich#recipes = [{'buns': 'ListCount()', 'listexpr': 1, 'input': ['c']}]
call setline('.', '1foo1')
let s:count = 0
normal dib
call setline('.', '1foo1')
normal .
call s:assert(getline('.'), '11', 'textobj-query:listexpr #1')

call setline('.', '1foo1')
let s:count = 0
normal dab
call setline('.', '1foo1')
normal .
call s:assert(getline('.'), '', 'textobj-query:listexpr #2')

let g:sandwich#recipes = []
let g:textobj#sandwich#recipes = [{'buns': 'ListCount()', 'listexpr': 2, 'input': ['c']}]
call setline('.', '1foo1')
let s:count = 0
normal dib
call setline('.', '2foo2')
normal .
call s:assert(getline('.'), '22', 'textobj-query:listexpr #3')

call setline('.', '1foo1')
let s:count = 0
normal dab
call setline('.', '2foo2')
normal .
call s:assert(getline('.'), '', 'textobj-query:listexpr #4')

unlet g:sandwich#recipes
unlet g:textobj#sandwich#recipes
%delete

" external textobjct
let g:sandwich#recipes = []
let g:textobj#sandwich#recipes = [{'external': ['it', 'at'], 'noremap': 1, 'input': ['t']}]
call append(0, ['<title>fooo</title>', '<body>bar</body>'])
$delete
normal ggdib
normal j.
call s:assert(getline(1), '<title></title>', 'textobj-auto:external textobject #1')
call s:assert(getline(2), '<body></body>', 'textobj-auto:external textobject #2')

%delete

call append(0, ['<title>fooo</title>', '<body>bar</body>'])
$delete
normal ggdab
normal j.
call s:assert(getline(1), '', 'textobj-auto:external textobject #3')
call s:assert(getline(2), '', 'textobj-auto:external textobject #4')

unlet g:sandwich#recipes
unlet g:textobj#sandwich#recipes
%delete

" synchro option
let g:sandwich#recipes = []
let g:textobj#sandwich#recipes = [{'buns': ['foo', 'baz'], 'synchro': 1, 'input': ['f']}]
call append(0, ['foo bar baz', ' foo baaaaar baz'])
$delete
normal ggdib
normal jl.
call s:assert(getline(1), 'foobaz', 'textobj-auto: synchro option #1')
call s:assert(getline(2), ' foobaz', 'textobj-auto: synchro option #2')

%delete

call append(0, ['foo bar baz', ' foo baaaaar baz'])
$delete
normal ggdab
normal jl.
call s:assert(getline(1), '', 'textobj-auto: synchro option #3')
call s:assert(getline(2), ' ', 'textobj-auto: synchro option #4')

%delete

catch
  call s:quit_by_error()
endtry



qall!
