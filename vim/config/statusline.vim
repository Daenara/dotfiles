set laststatus=2

highlight StatusLine ctermfg=White cterm=NONE
highlight StatusLineNC ctermfg=White ctermbg=Blue cterm=NONE

highlight User1 ctermbg=242 ctermfg=White
highlight User2 ctermfg=242
highlight User3 ctermbg=240 ctermfg=White
highlight User4 ctermfg=240 ctermbg=242
highlight User5 ctermfg=240
set statusline=%3*\ %f\ %*
if &runtimepath =~ 'fugitive' "&& exists('*fugitive#head')
    set statusline+=%4*%*
    set statusline+=%1*\ \ %{fugitive#head()}\ %*%2*%*
else
    set statusline+=%5*%*
endif
set statusline+=%=     " right side now
set statusline+=%2*%*
set statusline+=%1*\ %y\ %*
set statusline+=%4*%*
set statusline+=%3*\ %p%%\ %*
