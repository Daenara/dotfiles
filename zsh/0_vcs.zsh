autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '%s' '%b' '%m'
zstyle ':vcs_info:*' actionformats '%s' '%b' '%m' '%a'
zstyle ':vcs_info:*' check-for-changes true

function vcs_enable() {
    vcs_info
}

function get_vcs_name() {
    echo -n $vcs_info_msg_0_
}
function get_vcs_branch() {
    echo -n $vcs_info_msg_1_
}
function get_vcs_unstaged() {

}
function get_vcs_staged() {

}
