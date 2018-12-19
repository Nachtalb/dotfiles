set number
set mouse=
set paste

execute pathogen#infect()
syntax on
filetype plugin indent on

autocmd BufNewFile,BufRead *.zcml set syntax=xml

colorscheme py-darcula

" File, Open dialog set to current file dir
set browsedir=buffer

" Auto close html tags
:iabbrev </ </<C-X><C-O>

set tabstop=4

set expandtab
