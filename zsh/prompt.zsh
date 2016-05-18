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
# dir=" %13<..<%~%<< "
#dir=${PWD/#HOME/~}
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
function get_dir(){
  local n=$1
  dir=${PWD/#$HOME/~}
  if [ -z $n ] || [ $n = 0 ];
    then echo -n $dir
  else
    array=()
    count_slash=$(grep -o "/" <<< "$dir" | wc -l)
    for (( i=1; i<=$count_slash+1; i++ ))
    do
      array[$i]=$(cut -d/ -f$i <<< "$dir")
    done
    elem=0
    newdir=""
    finish=false
    let count=$count_slash+1
    while [ $n -gt $elem ] && [ $((elem+1)) -lt $count_slash ]
    do
      if [ ! -z $newdir ]; then
        newdir="${array[$count]}/$newdir"
      else
        newdir="$array[$count]"
      fi
      let elem=$elem+1
      if [ $elem -eq $n ] && [ ! $finish ]; then
         newdir="..$newdir"   
      elif [ $((elem+1)) -eq $count_slash ]; then
         count=2
         finish=true
      elif [ $((elem+1)) -eq $n ]; then
         count=2
         newdir="../$newdir"
         finish=true
      else
         let count=$count-1
      fi
    done
    echo -n $newdir
    #if [ $n = 1 ]; then
    #  echo -n "../${array[count_slash+1]}"
    #elif [ $n = 2 ]; then
    #  echo -n "${array[2]}/../${array[count_slash+1]}"
    #fi 
  fi 
}
function directory(){
    dir=$(get_dir 0)
    #dir="%~"
    count=10
    while [ ${#dir} -gt 30 ]
    do
      dir="$(get_dir $count)"
      let count=$count-1
      if [ $count -eq 0 ]
        then
	  #dir="$dir"
          break 
      fi
    done
    echo -n $dir
}
function draw_segment_left(){
    local bg=$1 fg=$2 content=$3
    if [ ! -z $content ];
      then print -n "%K{$bg}$arrow_left_temp%F{$fg}$content%f%k"
      arrow_left_temp="%F{$bg}$arrow_left%f"
    fi
}
function build_prompt_left(){
    exitvar=$(exit_status)
    user=$(usercolor)
    host=" $user@%m "
    dir=$(directory)
    draw_segment_left 'green' '' $exitvar
    draw_segment_left 'yellow' 'red' $host
    draw_segment_left 'blue' 'red' $dir
    print -n $arrow_left_temp
    # print "\n$arrow_sep"
}
function draw_segment_right(){
    local bg=$1 fg=$2 content=$3
    if [ ! -z $content ];
        then print -n "%K{$arrow_right_temp}%F{$bg}$arrow_right%f%k%K{$bg}%F{$fg}$content%f%k"    
        arrow_right_temp=$bg
    fi
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
