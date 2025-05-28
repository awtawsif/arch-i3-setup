#!/bin/bash

# Color definitions - simplified and more reliable
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
NC="\033[0m"

# Consolidated package groups
PACKAGES=(
    # Core & System
    htop exa copyq bat upower alacritty brightnessctl nano nano-syntax-highlighting
    mousepad bash-completion i3-wm i3blocks fastfetch wget xss-lock
    bluez bluez-utils blueman nwg-look man-db ly network-manager-applet
    # File Management
    thunar thunar-volman thunar-archive-plugin gvfs gvfs-mtp
    unrar zip unzip xarchiver
    # UI & Theming
    feh flameshot dunst rofi rofi-emoji i3status-rust tumbler
    ttf-font-awesome ttf-jetbrains-mono-nerd noto-fonts-emoji
    gnome-themes-standard papirus-icon-theme
)

# Add this after the PACKAGES array
CHAOTIC_PACKAGES=(
    i3lock-color
)

# Add sudo credential caching
cache_sudo_credentials() {
    echo -e "${YELLOW}Caching sudo credentials...${NC}"
    sudo -v
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
}

# Simplified functions
check_system() {
    [[ "$(id -u)" == "0" ]] && { echo -e "${RED}Don't run as root${NC}"; exit 1; }
    cache_sudo_credentials || { echo -e "${RED}Failed to cache sudo credentials${NC}"; exit 1; }
    ping -c 1 8.8.8.8 >/dev/null 2>&1 || { echo -e "${RED}No internet connection${NC}"; exit 1; }
    [[ ! -f "./setup.sh" ]] && { echo -e "${RED}Run from correct directory${NC}"; exit 1; }
    for item in "40-libinput.conf" ".bashrc" ".config"; do
        [[ ! -e "$item" ]] && { echo -e "${RED}Missing: $item${NC}"; exit 1; }
    done
}

setup_yay() {
    command -v yay || {
        echo -e "${YELLOW}Setting up yay...${NC}"
        sudo -v  # Refresh sudo credentials before yay installation
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
        cd /tmp/yay-bin || return 1
        makepkg -s --noconfirm
        sudo pacman -U --noconfirm ./*.pkg.tar.zst
        cd - || return 1
        rm -rf /tmp/yay-bin
    }
}

setup_chaotic_aur() {
    echo -e "${YELLOW}Setting up Chaotic AUR...${NC}"

    # Install and sign the key
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com || return 1
    sudo pacman-key --lsign-key 3056513887B78AEB || return 1

    # Install chaotic-keyring and mirrorlist
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
        'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' || return 1

    # Add chaotic-aur to pacman.conf if not already present
    if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
        echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
    fi

    # Update package database
    sudo pacman -Sy
}

install_packages() {
    sudo pacman -Syu --noconfirm || return 1
    sudo pacman -S --noconfirm --needed "${PACKAGES[@]}" || return 1
}

install_chaotic_packages() {
    echo -e "${YELLOW}Installing Chaotic AUR packages...${NC}"
    sudo pacman -S --noconfirm --needed "${CHAOTIC_PACKAGES[@]}" || return 1
}

setup_git() {
    echo -e "${YELLOW}Configure Git? (y/n)${NC}"
    read -r response
    [[ "$response" == [yY] ]] && {
        read -rp "GitHub username: " username
        read -rp "GitHub email: " email
        git config --global user.name "$username"
        git config --global user.email "$email"
    }
}

install_browser() {
    echo -e "${YELLOW}Select browser:\n1) Firefox\n2) Chromium\n3) Brave\n4) Skip${NC}"
    read -rp "Choice [1-4]: " choice
    case $choice in
        1) sudo pacman -S --noconfirm firefox ;;
        2) sudo pacman -S --noconfirm chromium ;;
        3) yay -S --noconfirm brave-bin ;;
    esac
}

main() {
    echo -e "${CYAN}╔════════ System Setup Installation ════════╗${NC}"

    check_system
    setup_git
    setup_yay
    setup_chaotic_aur
    install_browser
    install_packages
    install_chaotic_packages

    # Quick setup commands
    sudo brightnessctl set 3% || true
    sudo systemctl enable bluetooth ly.service

    # Create dirs and copy files
    mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Music ~/Videos ~/Projects
    sudo mkdir -p /etc/X11/xorg.conf.d/
    sudo cp 40-libinput.conf /etc/X11/xorg.conf.d/
    cp .bashrc ~/
    cp -r .config ~/
    chmod +x ~/.config/set_random_wallpaper.sh
    rm -f ~/.bash_profile

    echo -e "${GREEN}Installation Complete! Please reboot.${NC}"
}

main "$@"
