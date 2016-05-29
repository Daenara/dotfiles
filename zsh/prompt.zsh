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
arrow_right=$'\ue0b2' #    
# colors
fg=255
bg=236
# uhrzeit
time="%F{$fg}%T%f"
arrow_left_temp=""
arrow_right_temp=""
function check_ssh(){
    if [ $SSH_CONNECTION ]; then
        echo -n "%F{$fg}SSH%f"
    else
        echo ""
    fi
}
function usercolor(){
    who=$(whoami)
    if [ "$who" = "root" ]; then
        fontcolor="088"
    elif [ "$who" = "daenara" ]; then
        fontcolor="063"
    elif [ "$who" = "seibel" ]; then
        fontcolor="021"
    else
        fontcolor="040"
    fi
    echo -n "%F{$fontcolor}%n%f"      
}

function exit_status(){
    if [ "$?" = "1" ]; then
        echo -n "%F{001}$cross%f"
    else
        echo -n ""
    fi
}
function get_dir(){
    local n=$1
    dir="${PWD/#$HOME/~}"
    # trennzeichen zwischen ordnern
    seperator="%F{000}/%f"
    # string der an gekürzten stellen angezeigt wird
    abridged="%F{$fg}..%f"
    # anzahl von / im pfad
    count_slash=$(grep -o "/" <<< "$dir" | wc -l)
    array=()
    # alle ordnernamen werden in array geschrieben
    for (( i=1; i<=$count_slash+1; i++ ))
    do
        array[$i]=$(cut -d/ -f$i <<< "$dir")
    done
    # maximale anzahl der pfadelemente
    max=$n
    # true wenn der ganze pfad ausgegeben werden soll, sonst false
    all=false
    if [ -z $n ] || [ $n = 0 ]; then
        let max=$count_slash+1
        all=true
    fi
    elem=0
    newdir=""
    # das aktuelle element im array ist das letzte
    let akt_elem=$count_slash+1
    while [ $max -ge $((elem+1)) ]
    do
        # wenn schon was im string steht
        if [ ! -z $newdir ]; then
            # wenn das nächste element das letzte sein soll (und nicht alle angezeigt werden sollen)
            # echo "elem: $elem; elem+1: $((elem+1)); max: $max; all: $all"
            if [[ $((elem+1)) -eq $max && $all == false ]]; then
                newdir="%F{$fg}${array[1]}%$seperator$abridged$seperator$newdir"
            # sonst
            else
                newdir="%F{$fg}${array[$akt_elem]}%f$seperator$newdir"
            fi
        # wenn der string leer ist aber nur ein element rein soll
        elif [[ $max -eq 1 && $akt_elem -gt 1 ]]; then
            newdir="$abridged%F{$fg}$array[$akt_elem]%f"
        # wenn der string nur leer ist
        else
            newdir="%F{$fg}$array[$akt_elem]%f"
        fi
        let elem=$elem+1
        let akt_elem=$akt_elem-1
    done
    echo -n $newdir
}
function directory(){
    dir=$(get_dir 0)
    count=10
    local zero='%([BSUbfksu]|([FBK]|){*})'
    while [ ${#${(S%%)dir//$~zero/}} -gt 30 ]
    do
        dir="$(get_dir $count)"
        let count=$count-1
        if [ $count -eq 0 ]; then
            break 
        fi
    done
    echo -n $dir
}
function draw_segment_left(){
    local bg=$1 content=$2
    if [ ! -z $content ]; then
        print -n "%K{$bg}$arrow_left_temp $content %k"
        arrow_left_temp="%F{$bg}$arrow_left%f"
    fi
}
function build_prompt_left(){
    exitvar=$(exit_status)
    user=$(usercolor)
    let color_0=$bg-1
    let color_1=$bg
    let color_2=$bg+2
    host="$user%F{000}@%f%F{$fg}%m%f"
    dir=$(directory)
    draw_segment_left $color_0 $exitvar
    draw_segment_left $color_1 $host
    draw_segment_left $color_2 $dir
    print -n $arrow_left_temp
}
function draw_segment_right(){
    local bg=$1 content=$2
    if [ ! -z $content ]; then 
        print -n "%K{$arrow_right_temp}%F{$bg}$arrow_right%f%k%K{$bg} $content %k"    
        arrow_right_temp=$bg
    fi
}
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
