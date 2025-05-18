#! /usr/bin/sh

# TODO: import get_color
# source "$HOME/.config/hypr/custom/scripts/get_colors.sh"
# # Get colors for fuzzel
# background=$(get_scss_color "background")

# Set default colors if extraction fails
windowsInfo='sort_by(.workspace.id) | .[] | (.workspace.id|tostring) + " | " + .initialClass + " - " +.title + "\t" + .address'

selected_window=$(
  hyprctl clients -j |
    jq "$windowsInfo" -r |
    fuzzel \
      --dmenu \
      --prompt='🪟 ❯ ' \
      --width=50 \
      --lines=5 \
      --line-height=30 \
      --with-nth=1 \
      --accept-nth=2

  # TODO: find away to align fuzzel colors with wallpaper
  # --background-color=$backgound
)

if [ -n "$selected_window" ]; then
  window_address=$(echo "$selected_window" | cut -f1)
  hyprctl dispatch focuswindow address:"$window_address"
fi
