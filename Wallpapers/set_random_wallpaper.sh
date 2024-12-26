#!/bin/bash

# Directory containing your wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Choose a random wallpaper
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Set the wallpaper using hsetroot
feh --no-fehbg --bg-fill "$RANDOM_WALLPAPER"
