#
# This shell prompt config file was created by promptline.vim
#
function __promptline_host {
  local only_if_ssh="1"

  if [ $only_if_ssh -eq 0 -o -n "${SSH_CLIENT}" ]; then
    if [[ -n ${ZSH_VERSION-} ]]; then print %m; elif [[ -n ${FISH_VERSION-} ]]; then hostname -s; else printf "%s" \\h; fi
  fi
}

function __promptline_last_exit_code {

  [[ $last_exit_code -gt 0 ]] || return 1;

  printf "%s" "$last_exit_code"
}
function __promptline_ps1 {
  local slice_prefix slice_empty_prefix slice_joiner slice_suffix is_prompt_empty=1

  # section "a" header
  slice_prefix="${a_bg}${sep}${a_fg}${a_bg}${space}" slice_suffix="$space${a_sep_fg}" slice_joiner="${a_fg}${a_bg}${alt_sep}${space}" slice_empty_prefix="${a_fg}${a_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "a" slices
  __promptline_wrapper "$(__promptline_host)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "b" header
  slice_prefix="${b_bg}${sep}${b_fg}${b_bg}${space}" slice_suffix="$space${b_sep_fg}" slice_joiner="${b_fg}${b_bg}${alt_sep}${space}" slice_empty_prefix="${b_fg}${b_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "b" slices
  __promptline_wrapper "$(if [[ -n ${ZSH_VERSION-} ]]; then print %n; elif [[ -n ${FISH_VERSION-} ]]; then printf "%s" "$USER"; else printf "%s" \\u; fi )" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "c" header
  slice_prefix="${c_bg}${sep}${c_fg}${c_bg}${space}" slice_suffix="$space${c_sep_fg}" slice_joiner="${c_fg}${c_bg}${alt_sep}${space}" slice_empty_prefix="${c_fg}${c_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "c" slices
  __promptline_wrapper "$(__promptline_cwd)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "x" header
  slice_prefix="${x_bg}${sep}${x_fg}${x_bg}${space}" slice_suffix="$space${x_sep_fg}" slice_joiner="${x_fg}${x_bg}${alt_sep}${space}" slice_empty_prefix="${x_fg}${x_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "x" slices
  __promptline_wrapper "${VIRTUAL_ENV##*/}" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "y" header
  slice_prefix="${y_bg}${sep}${y_fg}${y_bg}${space}" slice_suffix="$space${y_sep_fg}" slice_joiner="${y_fg}${y_bg}${alt_sep}${space}" slice_empty_prefix="${y_fg}${y_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "y" slices
  __promptline_wrapper "$(__promptline_vcs_branch)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "z" header
  slice_prefix="${z_bg}${sep}${z_fg}${z_bg}${space}" slice_suffix="$space${z_sep_fg}" slice_joiner="${z_fg}${z_bg}${alt_sep}${space}" slice_empty_prefix="${z_fg}${z_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "z" slices
  __promptline_wrapper "$(__promptline_git_status)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "warn" header
  slice_prefix="${warn_bg}${sep}${warn_fg}${warn_bg}${space}" slice_suffix="$space${warn_sep_fg}" slice_joiner="${warn_fg}${warn_bg}${alt_sep}${space}" slice_empty_prefix="${warn_fg}${warn_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "warn" slices
  __promptline_wrapper "$(__promptline_last_exit_code)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
  __promptline_wrapper "$(__promptline_battery)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # close sections
  printf "%s" "${reset_bg}${sep}$reset$space"
}
function __promptline_vcs_branch {
  local branch
  local branch_symbol=" "

  # git
  if hash git 2>/dev/null; then
    if branch=$( { git symbolic-ref --quiet HEAD || git rev-parse --short HEAD; } 2>/dev/null ); then
      branch=${branch##*/}
      printf "%s" "${branch_symbol}${branch:-unknown}"
      return
    fi
  fi
  return 1
}
function __promptline_cwd {
  local dir_limit="3"
  local truncation="⋯"
  local first_char
  local part_count=0
  local formatted_cwd=""
  local dir_sep="  "
  local tilde="~"

  local cwd="${PWD/#$HOME/$tilde}"

  # get first char of the path, i.e. tilde or slash
  [[ -n ${ZSH_VERSION-} ]] && first_char=$cwd[1,1] || first_char=${cwd::1}

  # remove leading tilde
  cwd="${cwd#\~}"

  while [[ "$cwd" == */* && "$cwd" != "/" ]]; do
    # pop off last part of cwd
    local part="${cwd##*/}"
    cwd="${cwd%/*}"

    formatted_cwd="$dir_sep$part$formatted_cwd"
    part_count=$((part_count+1))

    [[ $part_count -eq $dir_limit ]] && first_char="$truncation" && break
  done

  printf "%s" "$first_char$formatted_cwd"
}
function __promptline_left_prompt {
  local slice_prefix slice_empty_prefix slice_joiner slice_suffix is_prompt_empty=1

  # section "a" header
  slice_prefix="${a_bg}${sep}${a_fg}${a_bg}${space}" slice_suffix="$space${a_sep_fg}" slice_joiner="${a_fg}${a_bg}${alt_sep}${space}" slice_empty_prefix="${a_fg}${a_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "a" slices
  __promptline_wrapper "$(__promptline_host)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "b" header
  slice_prefix="${b_bg}${sep}${b_fg}${b_bg}${space}" slice_suffix="$space${b_sep_fg}" slice_joiner="${b_fg}${b_bg}${alt_sep}${space}" slice_empty_prefix="${b_fg}${b_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "b" slices
  __promptline_wrapper "$(if [[ -n ${ZSH_VERSION-} ]]; then print %n; elif [[ -n ${FISH_VERSION-} ]]; then printf "%s" "$USER"; else printf "%s" \\u; fi )" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "c" header
  slice_prefix="${c_bg}${sep}${c_fg}${c_bg}${space}" slice_suffix="$space${c_sep_fg}" slice_joiner="${c_fg}${c_bg}${alt_sep}${space}" slice_empty_prefix="${c_fg}${c_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "c" slices
  __promptline_wrapper "$(__promptline_cwd)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # close sections
  printf "%s" "${reset_bg}${sep}$reset$space"
}
function __promptline_wrapper {
  # wrap the text in $1 with $2 and $3, only if $1 is not empty
  # $2 and $3 typically contain non-content-text, like color escape codes and separators

  [[ -n "$1" ]] || return 1
  printf "%s" "${2}${1}${3}"
}
function __promptline_git_status {
  [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || return 1

  local added_symbol="●"
  local unmerged_symbol="✗"
  local modified_symbol="+"
  local clean_symbol="✔"
  local has_untracked_files_symbol="U"
  local deleted_symbol="-"
  local ahead_symbol="↑"
  local behind_symbol="↓"

  local unmerged_count=0 modified_count=0 has_untracked_files=0 added_count=0 is_clean="" deleted_count=0 untracked_count=0

  set -- $(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
  local behind_count=$1
  local ahead_count=$2

  # Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R), changed (T), Unmerged (U), Unknown (X), Broken (B)
  while read line; do
    case "$line" in
      M*) modified_count=$(( $modified_count + 1 )) ;;
      U*) unmerged_count=$(( $unmerged_count + 1 )) ;;
      D*) deleted_count=$(( $deleted_count + 1 )) ;;
    esac
  done < <(git diff --name-status)

  while read line; do
    case "$line" in
      *) added_count=$(( $added_count + 1 )) ;;
    esac
  done < <(git diff --name-status --cached)

  while read line; do
    case "$line" in
      *) untracked_count=$(( $untracked_count + 1 )) ;;
    esac
  done < <(git ls-files --others --exclude-standard)

  #if [ -n "$(git ls-files --others --exclude-standard)" ]; then
  #  has_untracked_files=1
  #fi

  if [ $(( unmerged_count + modified_count + has_untracked_files + added_count )) -eq 0 ]; then
    is_clean=1
  fi

  local leading_whitespace=""
  [[ $ahead_count -gt 0 ]]         && { printf "%2s" "$leading_whitespace$ahead_symbol$ahead_count"; leading_whitespace=" "; }
  [[ $behind_count -gt 0 ]]        && { printf "%2s" "$leading_whitespace$behind_symbol$behind_count"; leading_whitespace=" "; }
  [[ $modified_count -gt 0 ]]      && { printf "%2s" "$leading_whitespace$modified_symbol$modified_count"; leading_whitespace=" "; }
  [[ $deleted_count -gt 0 ]]       && { printf "%2s" "$leading_whitespace$deleted_symbol$deleted_count"; leading_whitespace=" "; }
  [[ $unmerged_count -gt 0 ]]      && { printf "%2s" "$leading_whitespace$unmerged_symbol$unmerged_count"; leading_whitespace=" "; }
  [[ $added_count -gt 0 ]]         && { printf "%2s" "$leading_whitespace$added_symbol$added_count"; leading_whitespace=" "; }
  [[ $untracked_count -gt 0 ]]     && { printf "%2s" "$leading_whitespace$has_untracked_files_symbol$untracked_count"; leading_whitespace=" "; }
  # [[ $has_untracked_files -gt 0 ]] && { printf "%2s" "$leading_whitespace$has_untracked_files_symbol"; leading_whitespace=" "; }
  [[ $is_clean -gt 0 ]]            && { printf "%2s" "$leading_whitespace$clean_symbol"; leading_whitespace=" "; }
}

function __promptline_battery {
  local percent_sign="%"
  local battery_symbol=""
  local threshold="10"

  # escape percent "%" in zsh
  [[ -n ${ZSH_VERSION-} ]] && percent_sign="${percent_sign//\%/%%}"

  # osx
  if hash ioreg 2>/dev/null; then
    local ioreg_output
    if ioreg_output=$(ioreg -rc AppleSmartBattery 2>/dev/null); then
      local battery_capacity=${ioreg_output#*MaxCapacity\"\ \=}
      battery_capacity=${battery_capacity%%\ \"*}

      local current_capacity=${ioreg_output#*CurrentCapacity\"\ \=}
      current_capacity=${current_capacity%%\ \"*}

      local battery_level=$(($current_capacity * 100 / $battery_capacity))
      [[ $battery_level -gt $threshold ]] && return 1

      printf "%s" "${battery_symbol}${battery_level}${percent_sign}"
      return
    fi
  fi

  # linux
  for possible_battery_dir in /sys/class/power_supply/BAT*; do
    if [[ -d $possible_battery_dir && -f "$possible_battery_dir/energy_full" && -f "$possible_battery_dir/energy_now" ]]; then
      current_capacity=$( <"$possible_battery_dir/energy_now" )
      battery_capacity=$( <"$possible_battery_dir/energy_full" )
      local battery_level=$(($current_capacity * 100 / $battery_capacity))
      [[ $battery_level -gt $threshold ]] && return 1

      printf "%s" "${battery_symbol}${battery_level}${percent_sign}"
      return
    fi
  done

return 1
}
function __get_aws_account(){
  if [[ -n $AWS_PROFILE ]]; then
    echo "${AWS_PROFILE:+ }${AWS_PROFILE:u}${AWS_PROFILE:+ }"
    export AWS_ENV=${AWS_PROFILE:l}
    return
  fi
  if ! [[ -s ~/.aws/credentials ]]; then
    echo "${AWS_ENV:+ }${AWS_ENV:u}${AWS_ENV:+ }"
    return
  fi
  aws_account_name=""
  echo ":"
  export aws_account_name=$(awk -F'= ' '/aws_account_name/ {print $2}' ~/.aws/credentials)
  if [[ -z $aws_account_name ]]; then
    set -o pipefail
    aws_account_number=$(aws sts get-caller-identity | jq -r .Account || echo "1" )
    export aws_account_name=$(jq -rS '.accountList| sort_by(.accountName) | .[] | [.accountId, .accountName] | join(" ") | ascii_upcase' ~/.aws/sso_accounts.json | awk '/'$aws_account_number'/ {printf("%s", $2)}')
    echo "aws_account_name = $aws_account_name" >> ~/.aws/credentials
  fi
  if [ -n $aws_account_name ]; then
    export AWS_ENV=$aws_account_name
    echo " ${aws_account_name}"
  fi
}

function __aws_account_prefix() {
  aws_account_name=$(__get_aws_account)
  if [ -z $aws_account_name ]; then
    echo "${warn_sep_fg}${rsep}${warn_fg}${warn_bg}${space}"
  elif [[ "$aws_account_name" =~ "TEST" ]]; then
    echo "${fg_test_sep}${rsep}${bg_test}${fg_test}"
  elif [[ "$aws_account_name" =~ "QA" ]]; then
    echo "${fg_qa_sep}${rsep}${bg_qa}${fg_qa}"
  elif [[ "$aws_account_name" =~ "PROD" ]]; then
    echo "${fg_prod_wtf} ${rsep}${bg_prod}${fg_prod}"
  else
    echo "${fg_aws_sep}${rsep}${bg_aws}${fg_aws}"
  fi
}

function __promptline_right_prompt {
  local slice_prefix slice_empty_prefix slice_joiner slice_suffix

  # section "warn" header
  slice_prefix="${warn_sep_fg}${rsep}${warn_fg}${warn_bg}${space}" slice_suffix="$space${warn_sep_fg}" slice_joiner="${warn_fg}${warn_bg}${alt_rsep}${space}" slice_empty_prefix=""
  # section "warn" slices
  __promptline_wrapper "$(__promptline_last_exit_code)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }
  __promptline_wrapper "$(__promptline_battery)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }

  # section "x" header
  slice_prefix="${x_sep_fg}${rsep}${x_fg}${x_bg}${space}" slice_suffix="$space${x_sep_fg}" slice_joiner="${x_fg}${x_bg}${alt_rsep}${space}" slice_empty_prefix=""
  # section "x" slices
  __promptline_wrapper "${VIRTUAL_ENV##*/}" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_empty_prefix"; }
  __promptline_wrapper "$(__get_aws_account)" "$(__aws_account_prefix)" "$slice_suffix" && { slice_prefix="$slice_joiner"; }

  # section "y" header
  slice_prefix="${y_sep_fg}${rsep}${y_fg}${y_bg}${space}" slice_suffix="$space${y_sep_fg}" slice_joiner="${y_fg}${y_bg}${alt_rsep}${space}" slice_empty_prefix=""
  # section "y" slices
  __promptline_wrapper "${MODE_INDICATOR_PROMPT}" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }

  # section "z" header
  slice_prefix="${z_sep_fg}${rsep}${z_fg}${z_bg}${space}" slice_suffix="$space${z_sep_fg}" slice_joiner="${z_fg}${z_bg}${alt_rsep}${space}" slice_empty_prefix=""
  # section "z" slices
  __promptline_wrapper "$(__promptline_vcs_branch)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }
  __promptline_wrapper "$(__promptline_git_status)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }

  # close sections
  export _status="$git_state"
  printf "%s" "$reset"
}

function __promptline {
  local last_exit_code="${PROMPTLINE_LAST_EXIT_CODE:-$?}"

  local esc=$'[' end_esc=m
  if [[ -n ${ZSH_VERSION-} ]]; then
    local noprint='%{' end_noprint='%}'
  elif [[ -n ${FISH_VERSION-} ]]; then
    local noprint='' end_noprint=''
  else
    local noprint='\[' end_noprint='\]'
  fi
  local wrap="$noprint$esc" end_wrap="$end_esc$end_noprint"
  local space=" "
  local sep=""
  local rsep=""
  local alt_sep=""
  local alt_rsep=""
  local reset="${wrap}0${end_wrap}"
  local reset_bg="${wrap}49${end_wrap}"
  local a_fg="${wrap}38;5;59${end_wrap}"
  local a_bg="${wrap}48;5;188${end_wrap}"
  local a_sep_fg="${wrap}38;5;188${end_wrap}"
  local b_fg="${wrap}38;5;188${end_wrap}"
  local b_bg="${wrap}48;5;31${end_wrap}"
  local b_sep_fg="${wrap}38;5;31${end_wrap}"
  local c_fg="${wrap}38;5;231${end_wrap}"
  local c_bg="${wrap}48;5;24${end_wrap}"
  local c_sep_fg="${wrap}38;5;24${end_wrap}"
  local warn_fg="${wrap}38;5;232${end_wrap}"
  local warn_bg="${wrap}48;5;166${end_wrap}"
  local warn_sep_fg="${wrap}38;5;166${end_wrap}"
  local fg_aws="${wrap}38;5;231${end_wrap}"
  local fg_prod="${wrap}38;5;219${end_wrap}"
  local fg_test="${wrap}38;5;49${end_wrap}"
  local fg_qa="${wrap}38;5;228${end_wrap}"
  local bg_aws="${wrap}48;5;7${end_wrap}"
  local fg_aws_sep="${wrap}38;5;7${end_wrap}"
  local bg_prod="${wrap}48;5;1${end_wrap}"
  local fg_prod_wtf="${wrap}38;5;1${end_wrap}"
  local bg_test="${wrap}48;5;2${end_wrap}"
  local fg_test_sep="${wrap}38;5;2${end_wrap}"
  local bg_qa="${wrap}48;5;3${end_wrap}"
  local fg_qa_sep="${wrap}38;5;3${end_wrap}"
  local x_fg="${wrap}38;5;231${end_wrap}"
  local x_bg="${wrap}48;5;24${end_wrap}"
  local x_sep_fg="${wrap}38;5;24${end_wrap}"
  local y_fg="${wrap}38;5;188${end_wrap}"
  local y_bg="${wrap}48;5;31${end_wrap}"
  local y_sep_fg="${wrap}38;5;31${end_wrap}"
  local z_fg="${wrap}38;5;59${end_wrap}"
  local z_bg="${wrap}48;5;188${end_wrap}"
  local z_sep_fg="${wrap}38;5;188${end_wrap}"
  if [[ -n ${ZSH_VERSION-} ]]; then
    PROMPT="$(__promptline_left_prompt)"
    RPROMPT="$(__promptline_right_prompt)"
  elif [[ -n ${FISH_VERSION-} ]]; then
    if [[ -n "$1" ]]; then
      [[ "$1" = "left" ]] && __promptline_left_prompt || __promptline_right_prompt
    else
      __promptline_ps1
    fi
  else
    PS1="$(__promptline_ps1)"
  fi
}

if [[ -n ${ZSH_VERSION-} ]]; then
  if [[ ! ${precmd_functions[(r)__promptline]} == __promptline ]]; then
    precmd_functions+=(__promptline)
  fi
elif [[ -n ${FISH_VERSION-} ]]; then
  __promptline "$1"
else
  if [[ ! "$PROMPT_COMMAND" == *__promptline* ]]; then
    PROMPT_COMMAND='__promptline;'$'\n'"$PROMPT_COMMAND"
  fi
fi
export AWS_ENV="test"
#export GIT_STATUS=$(__promptline_git_status)

