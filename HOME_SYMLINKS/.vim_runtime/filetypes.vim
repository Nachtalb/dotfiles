"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Insert current datetime when typing 25/06/19 22:01:37
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
" Insert PDB statement
iab pdb __import__('pdb').set_trace()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Python section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako
au BufRead,BufNewFile *.scss set filetype=scss.css

au FileType python map <buffer> <leader>C ?class<CR>
au FileType python map <buffer> <leader>D ?def<CR>

autocmd FileType html,xml,zcml,pt,javascript,css,scss,sass,less,scss.css setlocal shiftwidth=2 tabstop=2 softtabstop=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => All Filetypes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! LoadDict()
    let path=expand('~/.vim/dictionaries/' . expand('%:e') . '.txt')
    if filereadable(path)
        exe 'setlocal dictionary+=' . path
    endif
endfun

au BufNewFile,BufRead * call LoadDict()
