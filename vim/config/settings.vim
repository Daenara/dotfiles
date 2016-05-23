set nocompatible
set term=rxvt-unicode-256color
set enc=utf-8
set shiftwidth=4
set linespace=0
set history=1000
" ##### search #####
set incsearch " search as characters are entered
set hlsearch " highlight matches
set ic " ignore case while searching

" ##### editor #####
set number " show line numbers
set cursorline " highlight current line
set wildmenu " visual autocomplete for command menu
set showmatch " highlight matching [{()}]
set lazyredraw " redraw only when we need to
set wrap " display text in next line if line is to long
set linebreak " intelligent wrapping (spaces, etc)
set breakindent " match indent when wrapping lines
set whichwrap=b,s,<,>,[,] " arrowkeys can switch lines
set ai " autoindent
set si " smart indent
set showcmd " show commands in statusbar
filetype indent on " load filetype-specific indent files
syntax enable " enable syntax processing

" ##### tabs #####
set expandtab " tabs are replaced by spaces
set softtabstop=4 " number of spaces when editing 
set tabstop=4 " number of spaces shown for tab
