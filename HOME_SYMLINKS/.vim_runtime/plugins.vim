"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

execute pathogen#infect()

" Use the the_silver_searcher if possible (much faster than Ack)
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    let g:ackprg = 'ag --vimgrep --smart-case'

    " Use ag in CtrlP for listing files. Lightning fast and respects ."gitignore"
    " ToDo: fix this command, ATM it is not working correctly, I don't know
    " why tough
    "
    " let g:ctrlp_user_command = 'ag %s -l --nocolor -u -G "^(?!.*(\\.idea|\.svn|\\.git|node_modules|\\.DS_Store|\\.coffee)).*\$"'
    " ag is fast enough that CtrlP doesn't need to cache
    " let g:ctrlp_use_caching = 0
endif

" CtrlP configuration
let g:ctrlp_working_path_mode = 0  " respect working dir changes
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'

" AutoPais
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<M-b>'

" NerdTree
" let g:NERDTreeWinPos = "right"
" let NERDTreeShowHidden=1
" let NERDTreeIgnore = ['\.pyc$', '__pycache__']
" let g:NERDTreeWinSize=35
" map <leader>nn :NERDTreeToggle<cr>
" map <leader>nf :NERDTreeFind<cr>
