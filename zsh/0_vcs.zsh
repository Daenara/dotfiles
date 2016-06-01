typeset -A git_infos
function git_information() {
    git_infos=()
    git_infos[branch]=$(git symbolic-ref HEAD 2>/dev/null | cut -d'/' -f3)
    if [ ! -z $git_infos[branch] ]; then
        # get ahead and behind remote branch
        git_infos[ahead]=$(git rev-list ${git_infos[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        git_infos[behind]=$(git rev-list HEAD..${git_infos[branch]}@{upstream} 2>/dev/null | wc -l)
        #if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]; then
        #    git_infos[dirty]=true
        #else
        #    git_infos[dirty]=false
        #fi

        # get count of staged stashes
        #if [[ -s $(git rev-parse --git-dir)/refs/stash ]]; then
        #    git_infos[stashes]=$(git stash list 2>/dev/null | wc -l)
        #fi
        # Get number of files added to the index (but uncommitted)
        git_infos[added]=$(git status --porcelain 2>/dev/null| egrep "^(A|MM|M )" | wc -l)

        # Get number of files that are uncommitted and not added
        git_infos[unadded]=$(git status --porcelain 2>/dev/null| egrep "^(\?\?| M|MM)" | wc -l)

        # Get number of total uncommited files
        git_infos[uncommited]=$(git status --porcelain 2>/dev/null| wc -l)
    fi
}

function git_enable() {
    git_information
}
