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
# directory
dir=" %13<..<%~%<< "
# uhrzeit
time="%T"
arrow_left_temp=""
arrow_right_temp=""
function ssh(){
    if [ $SSH_CONNECTION ]; then
      echo -n "SSH"
    else
      echo ""
    fi
}

function usercolor(){
    if [ "$(whoami)" = "root" ]; then
      fontcolor="red"
    else
      fontcolor="green"
    fi
    echo -n "%F{$fontcolor}%n%f"      
}

function exit_status(){
    if [ "$?" = "1" ];
      then echo -n " %F{red}$cross%f "
    else
      echo -n ""
    fi
}

function draw_segment_left(){
    local bg=$1 fg=$2 content=$3
    if [ ! -z $content ];
    then print -n "%K{$bg}$arrow_left_temp%F{$fg}$content%f%k"
    arrow_left_temp="%F{$bg}$arrow_left%f"
fi
}
function build_prompt_left(){
    exit=$(exit_status)
    user=$(usercolor)
    host=" $user@%m "
    draw_segment_left 'green' '' $exit
    draw_segment_left 'yellow' 'red' $host
    draw_segment_left 'blue' 'red' $dir
    print -n $arrow_left_temp
    # print "\n$arrow_sep"
}
function draw_segment_right(){
    local bg=$1 fg=$2 content=$3
    print -n "%K{$arrow_right_temp}%F{$bg}$arrow_right%f%k%K{$bg}%F{$fg}$content%f%k"    
     arrow_right_temp=$bg
}
function build_prompt_right(){
    ssh=$(ssh)
    draw_segment_right 'green' 'red' $time
    draw_segment_right 'blue'  'red' $ssh
   # draw_segment_right 'green' 'red' $time
}


# prompt links
PROMPT='$(build_prompt_left)'
# prompt rechts
RPROMPT='$(build_prompt_right)'
