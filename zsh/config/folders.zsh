# function to switch and save the current path
function cd() {
    builtin cd "$@";
    echo "$PWD" > $ZSH/run/currentfolder;
}
function swd() {
    echo "$PWD" > $ZSH/run/workingdirectory;
}
export cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cds='cd "$(cat $ZSH/run/currentfolder)"'
alias cwd='cd "$(cat $ZSH/run/workingdirectory)"'

