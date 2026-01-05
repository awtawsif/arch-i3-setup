#!/bin/bash

# Color definitions - simplified and more reliable
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
NC="\033[0m"

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

main() {
    echo -e "${CYAN}╔════════ System Setup Installation ════════╗${NC}"

    check_system
    setup_git

    # Call the package installation script
    chmod +x ./install_packages.sh
    ./install_packages.sh

    # Quick setup commands
    sudo brightnessctl set 3% || true
    sudo systemctl enable bluetooth ly@tty2.service

    # Create dirs and copy files
    mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Music ~/Videos ~/Projects
    sudo mkdir -p /etc/X11/xorg.conf.d/
    sudo cp 40-libinput.conf /etc/X11/xorg.conf.d/
    cp .bashrc ~/
    cp .profile ~/
    source ~/.profile
    cp -r .config ~/
    rm -f ~/.bash_profile

    echo -e "${GREEN}Installation Complete! Please reboot.${NC}"
}

main "$@"
