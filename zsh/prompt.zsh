setopt prompt_subst
autoload -Uz promptinit
autoload -Uz colors && colors
promptinit
#PLUSMINUS="\u00b1"
#DETACHED="\u27a6"# ➦
#GEAR="\u2699"# ⚙
# colors
fg=255
bg=236
# uhrzeit
time="%F{$colors[fg]}%T%f"
arrow_left_temp=""
arrow_right_temp=""
typeset -A symbols
typeset -A colors
function __symbols(){
    symbols[cross]="\u2718"       # ✘
    symbols[branch]="\ue0a0"      # 
    symbols[arrow_r]="\ue0b2"     # 
    symbols[arrow_l]="\ue0b0"     # 
    symbols[arrow_sep_l]="\ue0b1" # 
    symbols[arrow_sep_r]="\ue0b3" # 
    symbols[lightning]="\u26a1"   # ⚡
    symbols[arrow_u]="\u2191"     # ↑
    symbols[arrow_d]="\u2193"     # ↓
    symbols[arrow_ud]="\u21c5"    # ⇅
    symbols[circle]="\u25c6"      # ∙
}
function __colors() {
    colors[fg]=255
    colors[bg]=236
    colors[uncommited]=160
    colors[added]=036
    colors[unadded]=154
    for (( i=1; i <= 5; i++ )); do
        colors[bg_-$i]=$(($colors[bg]-$i))
        colors[bg_+$i]=$(($colors[bg]+$i))
    done
}
# output the ssh connection status (SSH if connected, else nothing)
function check_ssh(){
    if [ $SSH_CONNECTION ]; then
        echo -n "%F{$colors[fg]}SSH%f"
    else
        echo ""
    fi
}
# colors the username dependend on who it is
function usercolor(){
    local who=$(whoami)
    fontcolor="040"
    if [ "$who" = "root" ]; then
        fontcolor="088"
    elif [ "$who" = "daenara" ]; then
        fontcolor="063"
    elif [ "$who" = "seibel" ]; then
        fontcolor="021"
    fi
    echo -n "%F{$fontcolor}%n%f"
}
# display the exit status (red cross when 1 else empty)
function exit_status(){
    if [ "$?" = "1" ]; then
        echo -n "%F{001}$symbols[cross]%f"
    else
        echo -n ""
    fi
}
# get the actual folder abridged to n segments
function get_dir(){
    local max=$1
    akt_dir="${PWD/#$HOME/~}"
    # seperator for folders
    seperator="%F{000}/%f"
    # string showing where the path was abridged
    abridged="%F{$colors[fg]}..%f"
    # number of / in path
    count_slash=$(grep -o "/" <<< "$akt_dir" | wc -l)
    array=()
    # put all folders in path in array
    for (( i=1; i<=$count_slash+1; i++ )); do
        array[$i]=$(cut -d/ -f$i <<< "$akt_dir")
    done
    # true to return whole path, else false
    all=false
    if [ -z $max ] || [ $max = 0 ] || [ $max -ge $((count_slash+1)) ]; then
        let max=$count_slash+1
        all=true
    fi
    elem=0
    newdir=""
    # sets the pointer to the last element in array
    let act_elem=$count_slash+1
    while [ $max -ge $((elem+1)) ]; do
        # if output string not empty
        if [ ! -z $newdir ]; then
            # if next element will be the last (and not whole path is outputted)
            if [[ $((elem+1)) -eq $max && $all == false ]]; then
                newdir="%F{$colors[fg]}${array[1]}%f$seperator$abridged$seperator$newdir"
            # else
            else
                newdir="%F{$colors[fg]}${array[$act_elem]}%f$seperator$newdir"
            fi
        # if output string is empty and will contain only one element
        elif [[ $max -eq 1 && $act_elem -gt 1 ]]; then
            newdir="$abridged%F{$colors[fg]}$array[$act_elem]%f"
        # if output string is empty
        else
            newdir="%F{$colors[fg]}$array[$act_elem]%f"
        fi
        let elem=$elem+1
        let act_elem=$act_elem-1
    done
    echo -n $newdir
}
# strips the string of all zsh format expressions
get_visible_string() {
    local zero='%([BSUbfksu]|([FB]|){*})'
    echo -n ${${(S%%)1//$~zero}}
}
# outputs the current directory abridged to given lenght (30 default)
function directory(){
    local len=$1
    if [ -z $len ] || [ $len -eq 0 ]; then
        len=30
    fi
    akt_dir="$(get_dir 0)"
    visible_dir="$(get_visible_string $akt_dir)"
    count=10
    while [ ${#visible_dir} -gt $len ]; do
        akt_dir="$(get_dir $count)"
        visible_dir="$(get_visible_string $akt_dir)"
        let count=$count-1
        if [ $count -eq 0 ]; then
            break
        fi
    done
    echo -n $akt_dir
}
# returns the lenght of the directory path dependend on the terminal width
function dir_len(){
    if [ $COLUMNS -le 80 ]; then
        echo 20
    elif [ $COLUMNS -le 160 ]; then
        echo 30
    elif [ $COLUMNS -le 180 ]; then
        echo 40
    else
        echo 50
    fi
}
# display git status on the left prompt
function git_status_left() {
    local branchname=$git_infos[branch]
    if [ ! -z $branchname ]; then
        local output=""
        if [[ $branchname == "master" ]]; then
            output="%F{$colors[fg]}$symbols[branch]"
        else
            output="%F{$colors[fg]}$symbols[cross]"
        fi
        output="$output $branchname"
        if [ $git_infos[ahead] -gt 0 ];then
            if [ $git_infos[behind] -eq 0 ]; then
                output="$output $symbols[arrow_u]"
            else
                output="$output $symbols[arrow_ud]"
            fi
        elif [ $git_infos[behind] -gt 0 ]; then
            output="$output $symbols[arrow_d]"
        fi
        output="$output%f"
        echo -n $output
    fi
}
# display git status on right prompt
function git_status_right() {
    local branchname=$git_infos[branch]
    if [ ! -z $branchname ]; then
        local output=""
        if [ $git_infos[uncommited] -gt 0 ]; then
            output="$output%F{$colors[uncommited]}$symbols[circle]%f "
            if [ $git_infos[added] -eq 0 ]; then
                output="$output%F{green}$symbols[circle]%f "
            elif [ $git_infos[added] -lt 5 ]; then
                output="$output%F{$colors[added]}$symbols[circle]%f "
            fi
            if [ $git_infos[unadded] -eq 0 ]; then
                output="$output%F{green}$symbols[circle]%f"
            elif [ $git_infos[unadded] -lt 5 ]; then
                output="$output%F{$colors[unadded]}$symbols[circle]%f"
            fi
        fi
        echo -n $output
    fi
}
# draw a prompt segment for the left side of the prompt
function draw_segment_left(){
    local bg=$1 content=$2
    if [ ! -z $content ]; then
        print -n "%K{$bg}$arrow_left_temp $content %k"
        arrow_left_temp="%F{$bg}$symbols[arrow_l]%f"
    fi
}
# build the left side prompt
function build_prompt_left(){
    exitvar=$(exit_status)
    user=$(usercolor)
    host="$user%F{000}@%f%F{$colors[fg]}%m%f"
    akt_dir=$(directory $(dir_len))
    git_status_l=$(git_status_left)
    draw_segment_left $colors[bg_-1] $exitvar
    draw_segment_left $colors[bg] $host
    draw_segment_left $colors[bg_+1] $git_status_l
    draw_segment_left $colors[bg_+2] $akt_dir
    print -n $arrow_left_temp
}
# draw a prompt segment for the right side of the prompt
function draw_segment_right(){
    local bg=$1 content=$2
    if [ ! -z $content ]; then
        print -n "%K{$arrow_right_temp}%F{$bg}$symbols[arrow_r]%f%k%K{$bg} $content %k"
        arrow_right_temp=$bg
    fi
}
# build the right side prompt
function build_prompt_right(){
    ssh_status=$(check_ssh)
    git_status_r=$(git_status_right)
    draw_segment_right $colors[bg] $time
    draw_segment_right $colors[bg_-1] $git_status_r
    draw_segment_right $colors[bg_-2] $ssh_status
}
function precmd () {
    __symbols
    __colors
    vcs_enable
}
# prompt links
PROMPT='$(build_prompt_left)'
# prompt rechts
RPROMPT='$(build_prompt_right)'
