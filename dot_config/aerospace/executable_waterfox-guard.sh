#!/bin/bash
# Move the focused Waterfox window to workspace 4 if it's not on 4 or 5

CURRENT=$(aerospace list-workspaces --focused)

if [[ "$CURRENT" != "4" && "$CURRENT" != "5" ]]; then
    aerospace move-node-to-workspace 4
fi
