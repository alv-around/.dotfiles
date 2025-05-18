#!/bin/bash

scss_file="$HOME/.local/state/ags/scss/_material.scss"

# Function to extract a color value from the SCSS file
get_scss_color() {
  local variable_name="$1"
  grep "^\$${variable_name}: " "$scss_file" | awk -F ': ' '{print $2}' | tr -d ';'
}

# INFO: for debugging
# background=$(get_scss_color_for_fuzzel "background")
# echo "Background color for fuzzel: $background"
