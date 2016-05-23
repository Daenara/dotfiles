set nocompatible
set term=rxvt-unicode-256color
set enc=utf-8
set shiftwidth=4
set linespace=0
set history=1000
" ##### search #####
set incsearch " search as characters are entered
set hlsearch " highlight matches
set ignorecase " ignore case while searching
set smartcase " try to use smartcases

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
set ruler " show current position
filetype indent on " load filetype-specific indent files
syntax enable " enable syntax processing
set mouse=a " enable mouse for all modes

" ##### tabs #####
set expandtab " tabs are replaced by spaces
set shiftwidth=4
set smarttab " be smart about tabs
set softtabstop=4 " number of spaces when editing 
set tabstop=4 " number of spaces shown for tab


" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
