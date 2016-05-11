export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM=screen-256color


# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# You may need to manually set your language environment
# export LANG=de_DE.UTF-8
 export LANG=en_US.UTF-8

# Prefered editor
export EDITOR='vim'

# Bigger History
HISTSIZE=20000
SAVEHIST=20000

ZLE_RPROMPT_INDENT=0
