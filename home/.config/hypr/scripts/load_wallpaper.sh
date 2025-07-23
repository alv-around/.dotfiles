#!/bin/bash

# export .cargo/bin so hyprland can run wallust
export PATH="$HOME/.cargo/bin:$PATH"

WALLPAPER_DIRECTORY=~/wallpapers

WALLPAPER=$(
  fd . "$WALLPAPER_DIRECTORY" -e jpg -e jpeg -e png -e gif -e bmp -e webp |
    shuf -n 1
)

hyprctl hyprpaper reload "$WALLPAPER"
hyprctl hyprpaper wallpaper ",$WALLPAPER"
echo "$WALLPAPER"
wallust run "$WALLPAPER"
killall -SIGUSR2 waybar
