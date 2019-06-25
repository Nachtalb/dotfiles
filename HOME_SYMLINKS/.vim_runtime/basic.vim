"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" Auto reda outside changes of file
set autoread

" Use the the_silver_searcher if possible (much faster than Ack)
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

"" Set internal shell of vim to bash instead of vim
if &shell =~# 'fish$'
    :set shell=bash
endif

set lazyredraw

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set number
set mouse=

" Search
set incsearch
set hlsearch
set showcmd

"" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

"" Ignore case when searching
set ignorecase

" Turn on wildmenu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set wildignore+=*/.hg/*,*/.svn/*,*/.DS_Store

" Turn on ruler
set ruler

" File, Open dialog set to current file dir
set browsedir=buffer

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Show tabs / newlines / trailing whitespaces etc.
set encoding=utf-8

set list
set listchars=tab:‣\ ,eol:↵,trail:·,extends:»,precedes:«

" Add a bit extra margin to the left
set foldcolumn=0

" Disable code folding
set nofoldenable

" Do not wrap lines
set nowrap


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Syntax
syntax on
filetype plugin indent on

autocmd BufNewFile,BufRead *.zcml set syntax=xml
autocmd BufNewFile,BufRead *.fish set syntax=sh

" Theme
color desert

set cursorline
hi CursorLine cterm=NONE  ctermbg=Black
hi ErrorMsg ctermfg=255
hi CursorLineNR cterm=NONE ctermbg=red ctermfg=Yellow

hi Search cterm=NONE ctermfg=DarkGrey ctermbg=LightGrey
hi IncSearch cterm=NONE ctermfg=DarkGrey ctermbg=LightRed

hi MatchParen ctermfg=DarkGrey

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Cause cursor to not reach bottom and top of the window if possible
set scrolloff=10

fun! ToggleCC()
  if &cc == ''
    set colorcolumn=80,90,120
  else
    set colorcolumn=
  endif
endfun

set colorcolumn=80,90,120
hi ColorColumn cterm=NONE ctermbg=Black


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set colorcolumn=80,90,120
hi ColorColumn cterm=NONE ctermbg=Black


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Disable python plugin defined tab withs
let g:python_recommended_style = 0


"" When searching try to be smart about cases
set smartcase

" For regular expressions turn magic on
set magic

" Auto close html tags
iabbrev </ </<C-X><C-O>

" Tabs widths
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Trim WhiteSpace
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


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

noremap <Leader>cw :let @" = expand("%")<CR>
noremap <Leader>cf :let @" = expand("%:p")<CR>

" Change working directory to parent dir
" %=current file, p=get full path, h=get dirname
noremap <Leader>cp :cd ..<CR>
noremap <Leader>cf :cd %:p:h<CR>

" Write buffer if updated on CTRL-s
inoremap <C-s> <C-o>:update<CR>
noremap <C-s> :update<CR>

" Quit buffer with CTRL-q
inoremap <C-q> <C-o>:q<CR>
noremap <C-q> :q<CR>

" Autoclose xml tag with ,/
imap ,/ </<C-X><C-O>

nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Toggle paste mode on and off
map <leader>cc :setlocal number! <bar> :setlocal list! <bar> :GitGutterBufferToggle <bar> :call ToggleCC()<cr>

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

noremap <leader>S :%s/\<<C-r><C-w>\>//g<Left><Left>
noremap <leader>s /<C-r><C-w>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Auto reload ~/.vimrc
autocmd BufWritePost .vimrc,basic.vim source ~/.vimrc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fast editing and reloading of vimrc configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>e :e! ~/.config/omf/HOME_SYMLINKS/.vimrc<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Bash like keys for the command line
cnoremap <C-A>        <Home>
cnoremap <C-E>        <End>
cnoremap <C-K>        <C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
ab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
ab pdb import pdb; pdb.set_trace()


""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""

let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python map <buffer> <leader>C ?class<CR>
au FileType python map <buffer> <leader>D ?def<CR>
