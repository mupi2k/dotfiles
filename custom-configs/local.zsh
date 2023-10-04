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

push () {
  gitlab=$(git remote get-url origin | grep gitlab)
  while getopts ":a:t:m:do" flag
  do
    case "${flag}" in
      a) git add ${OPTARG};;
      t) if [[ -n $gitlab ]]; then
          target=${OPTARG}
        else
          echo "cannot create merge requests via cli on github"
          target=""
          fi;;
      m) message=${OPTARG};;
      o) _open='open $(pbpaste)';;
      d) draft="-o merge_request.draft";;
      :) if [[ ${OPTARG} == "a" ]]; then
          git add .
        elif [[ ${OPTARG} == "t" ]]; then
          if [[ -n  $gitlab ]]; then
            target=$(git branch -l master main | sed 's/^[ *]*//')
          else
            echo "cannot create merge requests via cli on github"
            target=""
          fi
          fi;;
    esac
  done
  if [[ -z $1 ]]; then
    cat <<- END
    Usage: $0 [-a <file/path to add>] [-a] [-d] [-t <branch>] [-m] "commit message"
      - With no flags, $0 will run 'git commit -am' with your commit message, then
         git push, and if the repo is in gitlab, will create an MR against main|master.
      - -a by itself will run 'git add .' before your git commit
      - -a with a path will add just that path. Multiple -a flags are allowed, and all will be
         'git add'-ed
     - -t allows you specify a branch other than main/master as the target (eg '-t test')
     - -d marks the MR as a draft
     - -m exists so you can run '$0 -atm' flags :D  Also it allows you to put your commit message
         someplace other than the last arg.
     - If you use multiple -t or -m args, only the last one will be used.
END
  else
    if [[ -z $message ]]; then
      message=${@: -1}
    fi
    branch=$(git status | awk '/On\ branch/ {print $3}')
    if (! [[ $message =~ $branch ]]); then
      message="[${branch}] ${message}"
    fi
    git commit -am ${message}
    if [[ -z $flag ]]; then
      if [[ -n $gitlab ]]; then
        if [[ -z $target ]]; then
            target=$(git branch -l master main | sed 's/^[ *]*//')
        fi
        git push  -o merge_request.create -o merge_request.target=${target} -o merge_request.title=${message} 2> >(grep -o 'https.*' | pbcopy)
        echo "MR $(pbpaste) created against branch ${target}; URL is copied to your clipboard"
      else
        git push
        echo "did not create MR because upstream repo is not in GitLab"
      fi
    else
      if [[ -n $gitlab ]]; then
        if [[ -z $target ]]; then
            target=$(git branch -l master main | sed 's/^[ *]*//')
        fi
        git push  ${draft} -o merge_request.create -o merge_request.target=${target} -o merge_request.title=${message} 2> >(grep -o 'https.*' | pbcopy)
        if [[ -n $(pbpaste) ]]; then
          echo "MR $(pbpaste) created against branch ${target}; URL is copied to your clipboard"
        fi
      else
        git push
        echo "did not create MR because upstream repo is not in GitLab"
      fi
      if [[ -n $(pbpaste) ]] && [[ -n $_open ]]; then
        sh -c $_open
      fi
    fi
  fi
}

export GITLAB_READ_TOKEN=glpat-m3zCevP1Ko8j86psUcY3
if [[ -f $HOME/rs/ws-pulumi-autologin/pulumi.sh ]]; then
    source $HOME/rs/ws-pulumi-autologin/pulumi.sh
fi
alias girl="grep -iRl --exclude-dir='node_packages' --exclude-dir='_temp' --exclude-dir='.git'"
