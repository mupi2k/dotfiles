# shellcheck shell=bash
# mm-porterm — colors mirroring tmuxline.conf
# Palette:
#   24  = steel blue (status bar background)
#   31  = medium blue (current window bg, highlighted segments)
#   188 = light beige (session/hostname bg; highlighted segment fg)
#   59  = dark muted  (text on beige segments)
#   231 = near-white  (text on blue segments)

if tp_patched_font_in_use; then
	TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
	TMUX_POWERLINE_SEPARATOR_LEFT_THIN=""
	TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
	TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=""
else
	TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◀"
	TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
	TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="▶"
	TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
fi

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-'24'}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-'231'}
# shellcheck disable=SC2034
TMUX_POWERLINE_SEG_AIR_COLOR=$(tp_air_color)

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}

# Current window: medium blue bg (31), beige fg (188), bar-blue (24) arrows
# shellcheck disable=SC2128
if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_CURRENT" ]; then
	TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
		"#[fg=colour24,bg=colour31,nobold,nounderscore,noitalics]"
		"$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
		"#[fg=colour188,bg=colour31] #I#F "
		"$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN"
		" #W "
		"#[fg=colour31,bg=colour24,nobold,nounderscore,noitalics]"
		"$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
	)
fi

# Inactive windows: near-white (231) on bar bg (24) — tp_format regular covers this
# shellcheck disable=SC2128
if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_STYLE" ]; then
	TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
		"$(tp_format regular)"
	)
fi

# shellcheck disable=SC2128
if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_FORMAT" ]; then
	TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
		"#[$(tp_format regular)]"
		"  #I#{?window_flags,#F, } "
		"$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN"
		" #W "
	)
fi

# shellcheck disable=SC1143,SC2128
if [ -z "$TMUX_POWERLINE_LEFT_STATUS_SEGMENTS" ]; then
	TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
		"tmux_session_info 188 59"         # beige bg, dark text  (matches tmuxline session)
		"hostname 31 231"                  # medium blue bg, near-white text
		#"mode_indicator 31 188"
		#"ifstat 24 231"
		#"ifstat_sys 24 231"
		"lan_ip 24 231 ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}"
		#"vpn 24 231 ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}"
		"wan_ip 24 231"
		"pwd 31 188"
	)
fi

# shellcheck disable=SC1143,SC2128
if [ -z "$TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS" ]; then
	TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
		#"earthquake 31 231"
		"vcs_branch 188 59"
		"vcs_compare 188 59"
		"vcs_staged 188 59"
		"vcs_modified 188 59"
		"vcs_others 188 59"
		"aws_account 188 59 default_separator no_sep_bg_color no_sep_fg_color both_disable separator_disable"
		#"macos_notification_count 24 231"
		#"mailcount 24 231"
		#"now_playing 31 188"
		#"cpu 24 231"
		#"load 24 231"
		#"tmux_mem_cpu_load 24 231"
		#"tmux_continuum_save 24 231"
		#"tmux_continuum_status 24 231 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}"
		#"battery 24 231"
		"battery 31 231"
		#"air ${TMUX_POWERLINE_SEG_AIR_COLOR} 231"
		#"weather 24 231"
		#"rainbarf 24 ${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR}"
		#"date_day 31 188"
		"date_day 24 231"
		"date 31 188"
		"time 31 188 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}"
		#"utc_time 31 188 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}"
		#"xkb_layout 31 188"
	)
fi
