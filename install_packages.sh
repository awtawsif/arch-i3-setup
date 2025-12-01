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
    mousepad visual-studio-code-bin bash-completion i3-wm i3blocks fastfetch wget xss-lock
    bluez bluez-utils blueman nwg-look man-db ly jq network-manager-applet xclip xdg-desktop-portal-gtk
    xdg-user-dirs polkit gparted
    # Audio & Media
    pipewire pipewire-pulse pipewire-alsa pavucontrol ffmpeg vlc mpv
    # Security
    firewalld
    # Node
    npm
    # File Management
    thunar thunar-volman thunar-archive-plugin gvfs gvfs-mtp
    unrar zip unzip xarchiver p7zip
    # UI & Theming
    feh flameshot dunst rofi rofi-emoji i3status-rust tumbler
    otf-font-awesome ttf-jetbrains-mono-nerd noto-fonts-emoji
    tokyonight-gtk-theme-git i3lock-color
    # Browser
    firefox
)

install_packages() {
    echo -e "${YELLOW}Updating system and installing packages with powerpill...${NC}"
    # Use powerpill for system update and package installation
    sudo pacman -Syu --noconfirm || return 1
    sudo pacman -S --noconfirm --needed "${PACKAGES[@]}" || return 1
}

main() {
    chmod +x ./setup_aur.sh
    ./setup_aur.sh
    install_packages # This function now uses powerpill
}

main "$@"
