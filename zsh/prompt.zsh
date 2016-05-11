setopt prompt_subst
autoload -Uz promptinit
autoload -Uz colors && colors
promptinit
arrow_left=$'\ue0b0' # 
arrow_sep=$'\ue0b1'
arrow_right=$'\ue0b2' # 
# hintergrundfarbe
background="blue"
# schriftfarbe
foreground="red"    
# user@rechner
host=" %F{$foreground}%n@%m%f "
# directory
dir="%~"
#uhrzeit
time="%F{$foreground}%T%f"
arrow_left_temp=""
arrow_right_temp=""

function draw_segment_left(){
    local bg=$1 fg=$2 content=$3
    print -n "%K{$bg}$arrow_left_temp%F{$fg}$content%f%k"
    arrow_left_temp="%F{$bg}$arrow_left%f"
}
function build_prompt_left(){
    draw_segment_left 'green' 'red' $host
    draw_segment_left 'blue' 'red' $dir
    print -n $arrow_left_temp
}
function draw_segment_right(){
    local bg=$1 fg=$2 content=$3
    print -n "%K{$arrow_right_temp}%F{$bg}$arrow_right%f%k%K{$bg}%F{$fg}$content%f%k"
    arrow_right_temp=$bg
}
function build_prompt_right(){
    draw_segment_right 'green' 'red' $time
    draw_segment_right 'blue' 'red' $time
}


# prompt links
PROMPT='$(build_prompt_left)'
# prompt rechts
RPROMPT='$(build_prompt_right)'
