#!/bin/sh
# Claude Code status line — user info + rate limits + context window

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')

# Shorten path to last 2 components (matching %2~)
short_path=$(echo "$cwd" | awk -F'/' '{
    n = NF
    if (n <= 2) { print $0 }
    else { print $(n-1) "/" $n }
}')

# Git branch
git_branch=$(git -C "$cwd" branch --no-optional-locks 2>/dev/null | sed -n 's/^\* \(.*\)/\1/p')

# Rate limits
five_h_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_h_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_d_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_d_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Context window
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Model
model_name=$(echo "$input" | jq -r '.model.display_name // empty')

# ANSI colors
C_USR='\033[38;2;151;204;241m'
C_DIR='\033[38;2;252;182;80m'
C_GIT='\033[38;2;225;90;96m'
C_GRN='\033[38;2;106;153;85m'
C_YLW='\033[38;2;231;167;77m'
C_RED='\033[38;2;205;83;89m'
C_DIM='\033[38;2;140;140;140m'
C_RST='\033[0m'

# Color based on percentage
color_for_pct() {
    pct="$1"
    warn_threshold="$2"
    crit_threshold="$3"
    int_pct=$(printf '%.0f' "$pct" 2>/dev/null || echo 0)
    if [ "$int_pct" -ge "$crit_threshold" ]; then
        printf '%s' "$C_RED"
    elif [ "$int_pct" -ge "$warn_threshold" ]; then
        printf '%s' "$C_YLW"
    else
        printf '%s' "$C_GRN"
    fi
}

# Format seconds until reset as human-readable
format_reset() {
    reset_ts="$1"
    if [ -z "$reset_ts" ]; then
        echo ""
        return
    fi
    now=$(date +%s)
    diff=$((reset_ts - now))
    if [ "$diff" -le 0 ]; then
        echo "now"
        return
    fi
    if [ "$diff" -ge 3600 ]; then
        hours=$((diff / 3600))
        mins=$(( (diff % 3600) / 60 ))
        echo "${hours}h${mins}m"
    elif [ "$diff" -ge 60 ]; then
        mins=$((diff / 60))
        echo "${mins}m"
    else
        echo "${diff}s"
    fi
}

# Build left side: user path [branch]
left=""
user=$(whoami)
left="${C_USR}${user}${C_RST} ${C_DIR}${short_path}${C_RST}"
if [ -n "$git_branch" ]; then
    left="${left} ${C_GIT}[${git_branch}]${C_RST}"
fi

# Build right side: rate limits + context
right=""

if [ -n "$five_h_pct" ]; then
    five_color=$(color_for_pct "$five_h_pct" 70 90)
    five_fmt=$(printf '%.1f' "$five_h_pct")
    five_reset=$(format_reset "$five_h_reset")
    reset_str=""
    if [ -n "$five_reset" ]; then
        reset_str=" ${C_DIM}${five_reset}${C_RST}"
    fi
    if [ -n "$right" ]; then
        right="${right} ${C_DIM}│${C_RST} "
    fi
    right="${right}${C_DIM}5h${C_RST} ${five_color}[${five_fmt}%]${C_RST}${reset_str}"
fi

if [ -n "$seven_d_pct" ]; then
    seven_color=$(color_for_pct "$seven_d_pct" 70 90)
    seven_fmt=$(printf '%.1f' "$seven_d_pct")
    seven_reset=$(format_reset "$seven_d_reset")
    reset_str=""
    if [ -n "$seven_reset" ]; then
        reset_str=" ${C_DIM}${seven_reset}${C_RST}"
    fi
    if [ -n "$right" ]; then
        right="${right} ${C_DIM}│${C_RST} "
    fi
    right="${right}${C_DIM}7d${C_RST} ${seven_color}[${seven_fmt}%]${C_RST}${reset_str}"
fi

if [ -n "$ctx_pct" ]; then
    ctx_color=$(color_for_pct "$ctx_pct" 50 80)
    ctx_fmt=$(printf '%.1f' "$ctx_pct")
    if [ -n "$right" ]; then
        right="${right} ${C_DIM}│${C_RST} "
    fi
    right="${right}${C_DIM}ctx${C_RST} ${ctx_color}[${ctx_fmt}%]${C_RST}"
fi

if [ -n "$model_name" ]; then
    if [ -n "$right" ]; then
        right="${right} ${C_DIM}│${C_RST} "
    fi
    right="${right}${C_DIM}${model_name}${C_RST}"
fi

# Output
if [ -n "$right" ]; then
    printf '%b %b' "$left" "$right"
else
    printf '%b' "$left"
fi
