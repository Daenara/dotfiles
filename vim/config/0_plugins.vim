call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

Plug 'flazz/vim-colorschemes' " colorschemes for vim
" Plug 'vim-airline/vim-airline' " vim powerline-like statusbar
Plug 'Yggdroot/indentLine' " show indent lines
Plug 'ervandew/supertab' " tabcompletion
Plug 'Raimondi/delimitMate' " autocloses brackets
Plug 'tpope/vim-fugitive' " git plugin for vim

" Add plugins to &runtimepath
call plug#end()
