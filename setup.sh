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
    mousepad bash-completion i3-wm i3blocks fastfetch wget xss-lock
    bluez bluez-utils blueman nwg-look man-db ly network-manager-applet xclip
    # File Management
    thunar thunar-volman thunar-archive-plugin gvfs gvfs-mtp
    unrar zip unzip xarchiver p7zip # rsync moved to install_powerpill_early
    # UI & Theming
    feh flameshot dunst rofi rofi-emoji i3status-rust tumbler
    otf-font-awesome ttf-jetbrains-mono-nerd noto-fonts-emoji
    gnome-themes-standard papirus-icon-theme
    # Packages previously from YAY_PACKAGES, now from Chaotic-AUR
    i3lock-color
    visual-studio-code-bin
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

# Function to set up Chaotic-AUR
setup_chaotic_aur() {
    echo -e "${YELLOW}Setting up Chaotic-AUR...${NC}"
    # Retrieve and sign the primary key
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com || { echo -e "${RED}Failed to retrieve Chaotic-AUR key${NC}"; return 1; }
    sudo pacman-key --lsign-key 3056513887B78AEB || { echo -e "${RED}Failed to sign Chaotic-AUR key${NC}"; return 1; }

    # Install chaotic-keyring and chaotic-mirrorlist packages
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm || { echo -e "${RED}Failed to install chaotic-keyring${NC}"; return 1; }
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm || { echo -e "${RED}Failed to install chaotic-mirrorlist${NC}"; return 1; }

    # Append the Chaotic-AUR repository to /etc/pacman.conf
    echo -e "${YELLOW}Appending Chaotic-AUR repository to /etc/pacman.conf...${NC}"
    if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
        echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
    else
        echo -e "${YELLOW}Chaotic-AUR entry already exists in /etc/pacman.conf, skipping append.${NC}"
    fi

    # Run a full system update to sync mirrorlist
    echo -e "${YELLOW}Running full system update to sync Chaotic-AUR mirrorlist...${NC}"
    sudo pacman -Syu --noconfirm || { echo -e "${RED}Failed to sync Chaotic-AUR mirrorlist${NC}"; return 1; }
}

# New function to install powerpill and its optional dependencies early using pacman and modify SigLevel
install_powerpill_early() {
    echo -e "${YELLOW}Installing powerpill, rsync and reflector${NC}"
    # Install powerpill and its optional dependencies (rsync, reflector)
    sudo pacman -S --noconfirm --needed powerpill rsync reflector || { echo -e "${RED}Failed to install powerpill and its dependencies${NC}"; return 1; }

    # Change SigLevel to PackageRequired in pacman.conf for powerpill
    echo -e "${YELLOW}Setting SigLevel to PackageRequired in /etc/pacman.conf for Powerpill...${NC}"
    if ! grep -q "SigLevel = PackageRequired" /etc/pacman.conf; then
        sudo sed -i '/^#\?SigLevel =/cSigLevel = PackageRequired' /etc/pacman.conf || { echo -e "${RED}Failed to set SigLevel in pacman.conf${NC}"; return 1; }
    else
        echo -e "${YELLOW}SigLevel is already set to PackageRequired, skipping modification.${NC}"
    fi
}

install_packages() {
    echo -e "${YELLOW}Updating system and installing packages with powerpill...${NC}"
    # Use powerpill for system update and package installation
    sudo powerpill -Syu --noconfirm || return 1
    sudo powerpill -S --noconfirm --needed "${PACKAGES[@]}" || return 1
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
        1) sudo powerpill -S --noconfirm firefox ;; # Use powerpill for browser installation
        2) sudo powerpill -S --noconfirm chromium ;; # Use powerpill for browser installation
        3) sudo powerpill -S --noconfirm brave-bin ;;
    esac
}

main() {
    echo -e "${CYAN}╔════════ System Setup Installation ════════╗${NC}"

    check_system
    setup_git
    setup_yay
    setup_chaotic_aur
    install_powerpill_early # Install powerpill and its dependencies, and set SigLevel
    install_browser
    install_packages # This function now uses powerpill

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
