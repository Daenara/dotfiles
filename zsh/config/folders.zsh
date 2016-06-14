# function to switch and save the current path
function cd() {
    builtin cd "$@";
    echo "$PWD" > $ZSH/run/currentfolder;
}
export cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cwd='cd "$(cat $ZSH/run/currentfolder)"'

