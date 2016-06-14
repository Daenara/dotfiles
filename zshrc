ZSH=${ZDOTDIR:-$HOME}/.zsh
for config ($ZSH/config/*.zsh) source $config
