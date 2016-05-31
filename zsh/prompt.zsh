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
time="%F{$fg}%T%f"
arrow_left_temp=""
arrow_right_temp=""
typeset -A symbols
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
}
# output the ssh connection status (SSH if connected, else nothing)
function check_ssh(){
    if [ $SSH_CONNECTION ]; then
        echo -n "%F{$fg}SSH%f"
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
    abridged="%F{$fg}..%f"
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
                newdir="%F{$fg}${array[1]}%f$seperator$abridged$seperator$newdir"
            # else
            else
                newdir="%F{$fg}${array[$act_elem]}%f$seperator$newdir"
            fi
        # if output string is empty and will contain only one element
        elif [[ $max -eq 1 && $act_elem -gt 1 ]]; then
            newdir="$abridged%F{$fg}$array[$act_elem]%f"
        # if output string is empty
        else
            newdir="%F{$fg}$array[$act_elem]%f"
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
# display git status
function git_status() {
    local branchname=$git_infos[branch]
    if [ ! -z $branchname ]; then
        local output=""
        if [[ $branchname == "master" ]]; then
            output="%F{$fg}$symbols[branch]"
        else
            output="%F{$fg}$symbols[cross]"
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
    let color_0=$bg-1
    let color_1=$bg
    let color_2=$bg+1
    let color_3=$bg+2
    host="$user%F{000}@%f%F{$fg}%m%f"
    akt_dir=$(directory $(dir_len))
    git_infos=$(git_status)
    draw_segment_left $color_0 $exitvar
    draw_segment_left $color_1 $host
    draw_segment_left $color_2 $git_infos
    draw_segment_left $color_3 $akt_dir
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
    let color_0=$bg
    let color_1=$bg-2
    ssh_status=$(check_ssh)
    draw_segment_right $color_0 $time
    draw_segment_right $color_1 $ssh_status
}
function precmd () {
    __symbols
    vcs_enable
}
# prompt links
PROMPT='$(build_prompt_left)'
# prompt rechts
RPROMPT='$(build_prompt_right)'
