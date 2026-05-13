#!/bin/sh

###############################################################################
##  git_linux_resources/bash/functions
##     functions for bashrc
##

# see ../readme.md

function title {
    echo -en "\033]2;$1\007"
    SCREEN_TITLE=$1
}

function jump() {
    if [ -z $1 ]; then
        #echo "Usage: jump [command]"
        if ! [ -z $DEBUG ]; then
            echo "running: /usr/bin/ssh -t -A -Y -p $BASTION_PORT  $BASTION_USERNAME@$BASTION_SERVER"
        fi
        /usr/bin/ssh -t -A -Y -p $BASTION_PORT $BASTION_USERNAME@$BASTION_SERVER
    elif [ "$1" = "-?" ]; then
        echo "Usage: jump [command]"
    else
        CMD=$1  #if we made it this far, there's at least a $1
        title "JUMP-$CMD"
        shift
        if [ -z "$1" ]; then
            if ! [ -z $DEBUG ]; then
                echo "running: /usr/bin/ssh -t -A -Y -p $BASTION_PORT  $BASTION_USERNAME@$DESKTOP $CMD"
            fi
            /usr/bin/ssh -t -A -Y -p $BASTION_PORT $BASTION_USERNAME@$BASTION_SERVER $CMD
        else
            if ! [ -z $DEBUG ]; then
                echo "running: /usr/bin/ssh -t -A -Y -p $BASTION_PORT $BASTION_USERNAME@$DESKTOP  $CMD \"$@\""
            fi
        /usr/bin/ssh -t -A -Y -p $BASTION_PORT $BASTION_USERNAME@$BASTION_SERVER $CMD "$@"
        fi
    fi
}

function jj() {
    if [ -z $1 ]; then
        echo "Usage: jj ssh-destination [ssh-command]"
    else
        DEST=$1  #we know if we are here, we have at least a $1
        shift
        if [ -z "$@" ]; then
            if ! [ -z $DEBUG ]; then
                echo "running: jump jscreen $DEST"
            fi
            jump jscreen $DEST
        else
            if ! [ -z $DEBUG ]; then
                echo "running: jump jscreen $DEST $@"
            fi
            jump jscreen $DEST $@
       fi
    fi
}

_get_parent_dir() {
  if [ -z ${1%/*} ]; then
	echo "/"
  else
	echo ${1%/*}
  fi
}

_get_pulumi_stack() {
  if [[ -n $1 ]]
  then
    if [[ $1 =~ 'stack' ]]
    then
      echo -n ${2}
    elif [[ "$1" = "/" ]]
    then
      _stack=$(pwd | cut -d '/' -f 5)
      if [[ $_stack =~ 'deleted|deletion' ]]
      then
        echo $_stack | rev | cut -d '-' -f 3- | rev
      else
        echo -n "${_stack}"
      fi
    elif [[ -d $1/config ]]
    then
      _stack=$(ls -1 $1/config 2>/dev/null | awk -F. '/Pulumi./ {print $(NF-1)}')
      if [[ -n $_stack ]]
      then
              echo -n "${_stack}"
      else
              _get_pulumi_stack $(_get_parent_dir $1)
      fi
    else
      _get_pulumi_stack $(_get_parent_dir $1)
    fi
  else
    _get_pulumi_stack $PWD
  fi
}

function pp() {
  export CI_PROJECT_URL=https://gitlab.com/$(git remote get-url --push origin 2> /dev/null | awk -F'[@:.]' '{print $(NF-1)}')
  if [[ -n $1 ]]; then
    if [[ $1 =~ 'stack' ]]; then
      shift
    fi
    _stack=${1}
    shift
  fi
  if [[ -z ${VERSION} ]] && [[ -n ${_stack} ]]; then
    v ${_stack}
  elif [[ -z ${VERSION} ]]; then
    v
  fi
  if [[ -z ${_stack} ]]; then
   pulumi preview --stack $(_get_pulumi_stack) $@
 else
   pulumi preview --stack ${_stack} $@
  fi
}

v () {
  if [[ -n $1 ]]; then
    if [[ $1 =~ 'stack' ]]; then
      shift
    fi
    _stack=${1}
    shift
  else
    _stack=$(_get_pulumi_stack)
  fi
  export VERSION=$(pulumi stack export --stack $_stack | jq -r --arg STACK $_stack '.deployment.resources[] | select(.type == "aws:ecs/taskDefinition:TaskDefinition").inputs.containerDefinitions | fromjson | map(select(.name == $STACK))[0].image' | cut -d ':' -f 2)
  export TIMESTAMP=$(pulumi stack export --stack $_stack | jq -r --arg STACK $_stack '.deployment.resources[] | select(.type == "aws:ecs/taskDefinition:TaskDefinition").inputs.containerDefinitions | fromjson | map(select(.name == $STACK))[0].environment[] | select(.name == "TIMESTAMP") | .value')
  echo $VERSION
  echo $TIMESTAMP
}


function psd () {
  pulumi stack --show-urns | awk -F '::' '/urn:pulumi:.*/ {if ($3 ~ /'$1'/) printf "%s => %s\n", $3, $NF}'
}

# Git: commit, push, and optionally create a GitLab MR
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
      - -a with a path will add just that path. Multiple -a flags are allowed.
      - -t allows you to specify a branch other than main/master as the target (eg '-t test')
      - -d marks the MR as a draft
      - -m exists so you can run '$0 -atm' flags :D
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
        git push -o merge_request.create -o merge_request.target=${target} -o merge_request.title=${message} 2> >(grep -o 'https.*' | pbcopy)
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
        git push ${draft} -o merge_request.create -o merge_request.target=${target} -o merge_request.title=${message} 2> >(grep -o 'https.*' | pbcopy)
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

function fzv {
  _fz=$(fzf)
  vim $_fz
  echo $_fz
}

function fzc {
  _fz=$(fzf)
  cd ${_fz%/*}
  echo $_fz
}

# Upgrade all yarn deps to latest exact versions
# TODO: add yarn berry (yarn berry: yarn up --latest)
function yule {
  echo "Happy Yule!"
  if [[ -f package.json ]]; then
    if [[ -n $1 ]]; then
      yarn upgrade $1 --latest --exact
    else
      yarn upgrade --latest --exact
    fi
  else
    echo "no package.json found in $(pwd)"
  fi
  echo "Happy Yule!"
}
