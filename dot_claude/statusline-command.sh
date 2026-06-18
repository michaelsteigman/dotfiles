#!/bin/sh
# Claude Code status line — mirrors key Powerlevel10k segments
input=$(cat)

user=$(whoami)
host=$(hostname -s)
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // ""')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Shorten home directory to ~
home="$HOME"
short_dir="${dir/#$home/\~}"

# Git branch (skip optional locks)
branch=""
if git -C "$dir" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$dir" -c core.fsmonitor="" symbolic-ref --short HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
  [ -n "$branch" ] && branch=" ($branch)"
fi

# Context remaining
ctx=""
if [ -n "$remaining" ]; then
  ctx=$(printf " | ctx: %.0f%% left" "$remaining")
fi

printf "\033[0;32m%s@%s\033[0m:\033[0;34m%s\033[0m\033[0;33m%s\033[0m | %s%s" \
  "$user" "$host" "$short_dir" "$branch" "$model" "$ctx"
