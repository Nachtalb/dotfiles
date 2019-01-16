set number
set mouse=
set paste

execute pathogen#infect()
syntax on
filetype plugin indent on

autocmd BufNewFile,BufRead *.zcml set syntax=xml

color desert

set cursorline
hi CursorLine cterm=none ctermbg=236
hi ErrorMsg ctermfg=255

" File, Open dialog set to current file dir
set browsedir=buffer

" Auto close html tags
iabbrev </ </<C-X><C-O>

" Tabs widths
:set tabstop=4
:set shiftwidth=4
:set expandtab

" Delete empty lines with backspace
set backspace=indent,eol,start

" Disable python plugin defined tab withs
let g:python_recommended_style = 0

" Show tabs / newlines / trailing whitespaces etc.
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<

" Trim whitespaces
function TrimWhiteSpace()
  %s/\s*$//
  ''
endfunction

autocmd FileWritePre * call TrimWhiteSpace()
autocmd FileAppendPre * call TrimWhiteSpace()
autocmd FilterWritePre * call TrimWhiteSpace()
autocmd BufWritePre * call TrimWhiteSpace()

" Remap for destroying trailing whitespace cleanly
nnoremap <Leader>w :let _save_pos=getpos(".") <Bar>
    \ let _s=@/ <Bar>
    \ %s/\s\+$//e <Bar>
    \ let @/=_s <Bar>
    \ nohl <Bar>
    \ unlet _s<Bar>
    \ call setpos('.', _save_pos)<Bar>
    \ unlet _save_pos<CR><CR>
