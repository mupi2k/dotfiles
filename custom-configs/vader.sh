#!/bin/sh

###############################################################################
##  git_linux_resources/bash/vader
##     functions to use my vps at vader.porterfam.us
##

# see ../readme.md

if [ -n $USE_PIE ]; then
function vader() {
        /usr/bin/ssh -t -A $BASTION_USERNAME@$BASTION_SERVER -p $BASTION_PORT \"ssh -t -A geekstuff@vader.porterfam.us\"
        }
fi

