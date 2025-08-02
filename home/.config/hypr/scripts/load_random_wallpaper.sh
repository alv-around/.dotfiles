#!/bin/bash

WALLPAPER_DIRECTORY=~/wallpapers

LAST_WALLPAPER_CACHE="$HOME/.cache/hyprland_last_wallpaper.txt"

WALLPAPER=$(
  fd . "$WALLPAPER_DIRECTORY" -e jpg -e jpeg -e png -e gif -e bmp -e webp |
    shuf -n 1
)

hyprctl hyprpaper reload "$WALLPAPER"
hyprctl hyprpaper wallpaper ",$WALLPAPER"
echo "$WALLPAPER"
wallust run "$WALLPAPER"
killall -SIGUSR2 waybar

cp "$WALLPAPER" "$LAST_WALLPAPER_CACHE"
