#!/bin/sh

###############################################################################
##  git_linux_resources/bash/pie
##     functions to use my server at pi.porterfam.us
##

# see ../readme.md

if [ -n $USE_PIE ]; then
function pie() {
        /usr/bin/ssh -t -A -Y -p 5280 mupi@pi.porterfam.us
        }
fi

