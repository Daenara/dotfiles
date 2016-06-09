set laststatus=2

highlight StatusLine ctermfg=White ctermbg=Black cterm=NONE
highlight StatusLineNC ctermfg=White ctermbg=Blue cterm=NONE

highlight User1 ctermbg=242 ctermfg=White
highlight User2 ctermfg=242 ctermbg=Black
highlight User3 ctermbg=240 ctermfg=White
highlight User4 ctermfg=240 ctermbg=242
:set statusline=%3*\ %f\ %*
:set statusline+=%4*%*
if &runtimepath =~ 'fugitive' "&& fugitive#is_git_dir(fnamemodify(getcwd(), ':t')) 
    :set statusline+=%1*\ \ %{fugitive#head()}\ %*%2*%*
endif
:set statusline+=%=     " right side now
:set statusline+=%2*%*
:set statusline+=%1*\ %y\ %*
:set statusline+=%4*%*
:set statusline+=%3*\ %p%%\ %*
