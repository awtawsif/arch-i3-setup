#!/bin/bash

# Color definitions - simplified and more reliable
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
NC="\033[0m"

# Consolidated package groups
PACKAGES=(
    # Core & System
    github-cli htop exa copyq bat upower alacritty brightnessctl nano nano-syntax-highlighting
    mousepad zed bash-completion i3-wm i3blocks fastfetch wget xss-lock
    bluez bluez-utils blueman nwg-look man-db ly jq network-manager-applet xclip xdg-desktop-portal-gtk
    # Node
    npm
    # File Management
    thunar thunar-volman thunar-archive-plugin gvfs gvfs-mtp
    unrar zip unzip xarchiver p7zip
    # UI & Theming
    feh flameshot dunst rofi rofi-emoji i3status-rust tumbler
    otf-font-awesome ttf-jetbrains-mono-nerd noto-fonts-emoji
    gnome-themes-standard papirus-icon-theme i3lock-color
)

install_packages() {
    echo -e "${YELLOW}Updating system and installing packages with powerpill...${NC}"
    # Use powerpill for system update and package installation
    sudo powerpill -Syu --noconfirm || return 1
    sudo powerpill -S --noconfirm --needed "${PACKAGES[@]}" || return 1
}

install_browser() {
    echo -e "${YELLOW}Select browser:\n1) Firefox\n2) Chromium\n3) Brave\n4) Librewolf\n5) Skip${NC}"
    read -rp "Choice [1-5]: " choice
    case $choice in
        1) sudo powerpill -S --noconfirm firefox ;; # Use powerpill for browser installation
        2) sudo powerpill -S --noconfirm chromium ;; # Use powerpill for browser installation
        3) sudo powerpill -S --noconfirm brave-bin ;;
        4) sudo powerpill -S --noconfirm librewolf;;
    esac
}

main() {
    chmod +x ./setup_aur.sh
    ./setup_aur.sh
    install_browser
    install_packages # This function now uses powerpill
}

main "$@"
