export HOMEBREW_GITHUB_API_TOKEN=5903cd5cb923d1d33a606e25ab18bc5eba0b8ca9

function facts {
  export ${1}=${3}
}

alias slide.dm="echo"

export WS_CLI="$HOME/rs/ws-cli"
export USE_RAMSEY="YES"
export USE_INTERACTIVE="yes"
#export  USE_IPMI="YES"
#export  USE_MOXA="YES"
export USE_FUNCTIONS="YES"
export USE_ALIASES="YES"
#export USE_EIGI="YES"
export USE_SCREEN="YES"
export USE_VADER="YES"
export USE_PIE="YES"
export JIRA_API_TOKEN="GgTSYZdQJgzzyklGY17v8034"
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
export ARTIFACTORY_TOKEN="cmVmdGtuOjAxOjE2OTIxOTc3NTM6VXJ3bXBHSDc3SVkweDJjbWkxOHExNjNpNHBT"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/rs/fzf-tab/fzf-tab.plugin.zsh

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with ls when completing cd
#  (only needed with fzf and fzf-tab)                                                                                                                                                zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'                                                                                                         # switch group using `,` and `.`                                                                                                                                                     zstyle ':fzf-tab:*' switch-group ',' '.'

# Enable fzf-tab tmux integration
#  (only if you have fzf-tab and tmux)
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

precmd () { __get_aws_account > /dev/null }
export PATH="$PATH:$HOME/.rd/bin"
alias assume="source assume"
