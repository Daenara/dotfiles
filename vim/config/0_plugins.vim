call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

Plug 'flazz/vim-colorschemes' " colorschemes for vim
Plug 'airblade/vim-rooter' " set vim working directory
Plug 'Yggdroot/indentLine' " show indent lines
"Plug 'ervandew/supertab' " tabcompletion
Plug 'Raimondi/delimitMate' " autocloses brackets
Plug 'tpope/vim-fugitive' " git plugin for vim
Plug 'Shougo/neocomplete.vim' " autocomplete
Plug 'Shougo/neco-vim'
"Plug 'sirver/ultisnips'

" Add plugins to &runtimepath
call plug#end()

" Plugin settings
let g:rooter_change_directory_for_non_project_files = ''
let g:rooter_targets = '/,*'
let g:rooter_silent_chdir = 1
let g:rooter_resolve_links = 1
