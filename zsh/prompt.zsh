setopt prompt_subst
autoload -Uz promptinit
autoload -Uz colors && colors
promptinit
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
cross="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"
arrow_left=$'\ue0b0' # 
arrow_sep=$'\ue0b1'
arrow_right=$'\ue0b2'
# colors
fg=255
bg=236
# uhrzeit
time="%F{$fg}%T%f"
arrow_left_temp=""
arrow_right_temp=""
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
        echo -n "%F{001}$cross%f"
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
# draw a prompt segment for the left side of the prompt
function draw_segment_left(){
    local bg=$1 content=$2
    if [ ! -z $content ]; then
        print -n "%K{$bg}$arrow_left_temp $content %k"
        arrow_left_temp="%F{$bg}$arrow_left%f"
    fi
}
# build the left side prompt
function build_prompt_left(){
    exitvar=$(exit_status)
    user=$(usercolor)
    let color_0=$bg-1
    let color_1=$bg
    let color_2=$bg+2
    host="$user%F{000}@%f%F{$fg}%m%f"
    akt_dir=$(directory $(dir_len))
    draw_segment_left $color_0 $exitvar
    draw_segment_left $color_1 $host
    draw_segment_left $color_2 $akt_dir
    print -n $arrow_left_temp
}
# draw a prompt segment for the right side of the prompt
function draw_segment_right(){
    local bg=$1 content=$2
    if [ ! -z $content ]; then
        print -n "%K{$arrow_right_temp}%F{$bg}$arrow_right%f%k%K{$bg} $content %k"
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

# prompt links
PROMPT='$(build_prompt_left)'
# prompt rechts
RPROMPT='$(build_prompt_right)'
