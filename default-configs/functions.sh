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

