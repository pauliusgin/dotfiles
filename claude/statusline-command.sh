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
ctx_input=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
ctx_cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
ctx_cache_write=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
ctx_output=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // 0')
ctx_window_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')

# Total input tokens in session (cumulative, for 5h/7d approximation)
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

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

# Format token count as Xk (e.g. 26600 → 26.6k, 200 → 200)
format_tokens() {
    n="$1"
    if [ "$n" -ge 1000 ] 2>/dev/null; then
        # Use awk for float division
        awk -v n="$n" 'BEGIN { k = n / 1000; printf "%.1fk", k }'
    else
        echo "${n}"
    fi
}

# Caveman plugin badge
C_CAVE='\033[38;2;205;133;63m'
caveman_badge=""
caveman_enabled=$(jq -r '.enabledPlugins["caveman@caveman"] // false' ~/.claude/settings.json 2>/dev/null)
if [ "$caveman_enabled" = "true" ]; then
    caveman_level=$(cat ~/.claude/.caveman-active 2>/dev/null)
    caveman_level="${caveman_level:-full}"
    caveman_badge="${C_CAVE}🗿 ${caveman_level}${C_RST}"
fi

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
    five_int=$(printf '%.0f' "$five_h_pct")
    five_reset=$(format_reset "$five_h_reset")
    # Derive approximate token count from cumulative session tokens scaled by 5h percentage
    reset_str=""
    if [ -n "$five_reset" ]; then
        reset_str=" ${C_DIM}${five_reset}${C_RST}"
    fi
    if [ -n "$right" ]; then
        right="${right} ${C_DIM}│${C_RST} "
    fi
    right="${right}${C_DIM}5h${C_RST} ${five_color}${five_int}%${C_RST}${reset_str}"
fi

if [ -n "$seven_d_pct" ]; then
    seven_color=$(color_for_pct "$seven_d_pct" 70 90)
    seven_int=$(printf '%.0f' "$seven_d_pct")
    seven_reset=$(format_reset "$seven_d_reset")
    reset_str=""
    if [ -n "$seven_reset" ]; then
        reset_str=" ${C_DIM}${seven_reset}${C_RST}"
    fi
    if [ -n "$right" ]; then
        right="${right} ${C_DIM}│${C_RST} "
    fi
    right="${right}${C_DIM}7d${C_RST} ${seven_color}${seven_int}%${C_RST}${reset_str}"
fi

if [ -n "$ctx_pct" ]; then
    ctx_int=$(printf '%.0f' "$ctx_pct")
    # Current context tokens: input + cache_read + cache_write (tokens in current context window)
    ctx_tokens=""
    ctx_total=0
    if [ "$ctx_input" -gt 0 ] 2>/dev/null || [ "$ctx_cache_read" -gt 0 ] 2>/dev/null; then
        ctx_total=$((ctx_input + ctx_cache_read + ctx_cache_write + ctx_output))
        ctx_tokens=$(format_tokens "$ctx_total")
    fi
    # Color priority: red if pct >= 80, yellow if total >= 100k, else green
    if [ "$ctx_int" -ge 80 ] 2>/dev/null; then
        ctx_color="$C_RED"
    elif [ "$ctx_total" -ge 100000 ] 2>/dev/null; then
        ctx_color="$C_YLW"
    else
        ctx_color="$C_GRN"
    fi
    if [ -n "$right" ]; then
        right="${right} ${C_DIM}│${C_RST} "
    fi
    if [ -n "$ctx_tokens" ]; then
        right="${right}${C_DIM}ctx${C_RST} ${ctx_color}${ctx_tokens} (${ctx_int}%)${C_RST}"
    else
        right="${right}${C_DIM}ctx${C_RST} ${ctx_color}${ctx_int}%${C_RST}"
    fi
fi

if [ -n "$model_name" ]; then
    if [ -n "$right" ]; then
        right="${right} ${C_DIM}│${C_RST} "
    fi
    right="${right}${C_DIM}${model_name}${C_RST}"
fi

if [ -n "$caveman_badge" ]; then
    right="${right} ${C_DIM}│${C_RST} ${caveman_badge}"
fi

# Output
if [ -n "$right" ]; then
    printf '%b %b' "$left" "$right"
else
    printf '%b' "$left"
fi
