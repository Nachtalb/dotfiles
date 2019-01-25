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
