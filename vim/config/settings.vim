set nocompatible " disable compability mode for vi
set term=rxvt-unicode-256color
set enc=utf-8
set linespace=0
set history=1000

" ##### search #####
set incsearch " search as characters are entered
set hlsearch " highlight matches
set ignorecase " ignore case while searching
set smartcase " try to use smartcases
set wrapscan " search next starts at top if end is reached

" ##### editor #####
set number " show line numbers
set cursorline " highlight current line
set wildmenu " visual autocomplete for command menu
set showmatch " highlight matching [{()}]
set lazyredraw " redraw only when we need to
set autoindent " autoindent
set smartindent " smart indent
set showcmd " show commands in statusbar
set ruler " show current position
filetype indent on " load filetype-specific indent files
filetype plugin on " load filetype-specific plugin files
syntax enable " enable syntax processing
set mouse=a " enable mouse for all modes

" #### wrapping ####
set wrap " display text in next line if line is to long
set linebreak " intelligent wrapping (spaces, etc)
set breakindent " match indent when wrapping lines
set whichwrap=b,s,<,>,[,] " arrowkeys can switch lines
let &showbreak='↳ ' " show arrow when line was wrapped

" ##### tabs #####
set expandtab " tabs are replaced by spaces
set shiftwidth=4
set smarttab " be smart about tabs
set softtabstop=4 " number of spaces when editing 
set tabstop=4 " number of spaces shown for tab

" #### directorys ####
set backupdir=~/.vim/.backupdir,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim/.backupdir,~/.tmp,~/tmp,/var/tmp,/tmp

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
