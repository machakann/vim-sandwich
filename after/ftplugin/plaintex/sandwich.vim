if &compatible || exists('b:did_sandwich_plaintex_ftplugin') || get(g:, 'sandwich_no_plaintex_ftplugin', 0)
  finish
endif

runtime after/ftplugin/initex/sandwich.vim
let b:did_sandwich_plaintex_ftplugin = 1
