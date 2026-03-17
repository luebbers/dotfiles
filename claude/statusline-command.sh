#!/usr/bin/env bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')

total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_window=$(echo "$input" | jq -r '.context_window.context_window_size // 0')

# Build context fill bar (10 chars wide)
if [ -n "$used_pct" ] && [ "$ctx_window" -gt 0 ] 2>/dev/null; then
  filled=$(echo "$used_pct" | awk '{printf "%d", $1 / 10}')
  empty=$((10 - filled))
  bar=""
  for i in $(seq 1 $filled); do bar="${bar}█"; done
  for i in $(seq 1 $empty);  do bar="${bar}░"; done
  ctx_display="${bar} ${used_pct}%"
else
  ctx_display="no data"
fi

# Shorten cwd: replace $HOME with ~
home_dir="$HOME"
short_cwd="${cwd/#$home_dir/\~}"

# Format token counts with K suffix for readability
format_tokens() {
  local n=$1
  if [ "$n" -ge 1000 ] 2>/dev/null; then
    echo "$n" | awk '{printf "%.1fK", $1/1000}'
  else
    echo "$n"
  fi
}

in_fmt=$(format_tokens "$total_in")
out_fmt=$(format_tokens "$total_out")

printf "\033[2m%s  ctx: %s  in: %s  out: %s  %s\033[0m" \
  "$model" "$ctx_display" "$in_fmt" "$out_fmt" "$short_cwd"
