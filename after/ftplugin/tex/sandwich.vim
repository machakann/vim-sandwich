if &compatible || exists('b:did_sandwich_tex_ftplugin') || get(g:, 'sandwich_no_tex_ftplugin', 0)
  finish
endif

runtime after/ftplugin/plaintex/sandwich.vim
let b:did_sandwich_tex_ftplugin = 1
