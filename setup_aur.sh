#!/bin/bash

# Color definitions - simplified and more reliable
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
NC="\033[0m"

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
    if ! grep -q "\[chaotic-aur]" /etc/pacman.conf;
    then
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
    if ! grep -q "SigLevel = PackageRequired" /etc/pacman.conf;
    then
        sudo sed -i '/^#\?SigLevel =/cSigLevel = PackageRequired' /etc/pacman.conf || { echo -e "${RED}Failed to set SigLevel in pacman.conf${NC}"; return 1; }
    else
        echo -e "${YELLOW}SigLevel is already set to PackageRequired, skipping modification.${NC}"
    fi
}

main() {
    setup_yay
    setup_chaotic_aur
    install_powerpill_early
}

main "$@"
