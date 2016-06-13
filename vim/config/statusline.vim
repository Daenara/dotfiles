set laststatus=2
set noruler

highlight StatusLine ctermfg=White cterm=NONE
highlight StatusLineNC ctermfg=White ctermbg=Blue cterm=NONE

highlight User1 ctermbg=242 ctermfg=White
highlight User2 ctermfg=242
highlight User3 ctermbg=240 ctermfg=White
highlight User4 ctermfg=240 ctermbg=242
highlight User5 ctermfg=240

function! ReadOnly()
    if &readonly || !&modifiable
        return ''
    else
        return ''
endfunction

function! GitInfo()
    let git = fugitive#head()
    if git != ''
        return '   '.fugitive#head().' '
    else
        return ''
endfunction

" Find out current buffer's size and output it.
function! FileSize()
    let bytes = getfsize(expand('%:p'))
    if (bytes >= 1024)
        let kbytes = bytes / 1024
    endif
    if (exists('kbytes') && kbytes >= 1000)
        let mbytes = kbytes / 1000
    endif
    if bytes <= 0
        return '0B'
    endif
    if(exists('mbytes'))
        return mbytes . 'MB'
    elseif (exists('kbytes'))
        return kbytes.'KB'
    else
        return bytes.'B'
    endif
endfunction

function! Arrow_left()
    return ''
endfunction

function! Arrow_right()
    return ''
endfunction

set statusline=%3*%{ReadOnly()}\ %f\ %*
let is_git_dir = system("git symbolic-ref HEAD 2>/dev/null | cut -d'/' -f3")
if !empty(is_git_dir)
    set statusline+=%4*%{Arrow_left()}%*
    set statusline+=%1*%{GitInfo()}%*%2*%{Arrow_left()}%*
else
    set statusline+=%5*%{Arrow_left()}%*
endif
set statusline+=%=
set statusline+=%2*%{Arrow_right()}%*
set statusline+=%1*\ %y\ %{FileSize()}\ %*
set statusline+=%4*%{Arrow_right()}%*
set statusline+=%3*\ %p%%\ %*
