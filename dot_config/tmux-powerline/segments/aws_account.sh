#!/usr/bin/env bash
# AWS environment indicator with dynamic background color.
#
# Reads AWS_PROFILE from per-pane tmux option @aws_profile (set by precmd hook
# in promptline.sh). Only displays if the session has been validated against
# aws sts get-caller-identity within the last hour. Validation runs in the
# background so it never blocks the status bar.
#
# Shows nothing if: pane hasn't synced yet, profile is unset, or session is
# expired and re-validation is pending/failed.
#
# Theme entry (between vcs_others and battery):
#   "aws_account 24 59 default_separator no_sep_bg_color no_sep_fg_color both_disable separator_disable"

readonly _AWS_SEP=$(printf '\xee\x82\xb2')   # U+E0B2 powerline bold left separator
readonly _AWS_VALIDATE_TTL=3600              # re-validate every hour

run_segment() {
    local pane_id
    pane_id=$(tmux display-message -p '#{pane_id}')

    local account
    account=$(tmux show-options -pqv -t "$pane_id" @aws_profile 2>/dev/null)
    [[ -z $account ]] && return 1

    local validated_at
    validated_at=$(tmux show-options -pqv -t "$pane_id" @aws_profile_validated 2>/dev/null)
    validated_at=${validated_at:-0}

    local now age
    now=$(date +%s)
    age=$(( now - validated_at ))

    if [[ $age -gt $_AWS_VALIDATE_TTL ]]; then
        # Only spawn one background validator at a time
        local validating
        validating=$(tmux show-options -pqv -t "$pane_id" @aws_profile_validating 2>/dev/null)
        if [[ -z $validating ]]; then
            tmux set-option -p -t "$pane_id" @aws_profile_validating "1"
            (
                if AWS_PROFILE="$account" aws sts get-caller-identity &>/dev/null; then
                    tmux set-option -p -t "$pane_id" @aws_profile_validated "$(date +%s)"
                else
                    tmux set-option -p -t "$pane_id" @aws_profile_validated "0"
                fi
                tmux set-option -pqu -t "$pane_id" @aws_profile_validating
            ) &>/dev/null &
            disown
        fi
        return 1
    fi

    local account_upper
    account_upper=$(printf '%s' "$account" | tr '[:lower:]' '[:upper:]')
    local bg fg
    if   [[ $account_upper == *PROD* ]]; then bg=1; fg=219
    elif [[ $account_upper == *QA*   ]]; then bg=3; fg=228
    elif [[ $account_upper == *TEST* ]]; then bg=2; fg=49
    else                                      bg=7; fg=231
    fi

    local prev_bg="${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-24}"
    printf '#[fg=colour%d,bg=colour%s]%s#[fg=colour%d,bg=colour%d] %s #[fg=colour%s,bg=colour%d]%s' \
        "$bg" "$prev_bg" "$_AWS_SEP" \
        "$fg" "$bg"      "$account_upper" \
        "$prev_bg" "$bg" "$_AWS_SEP"
}
