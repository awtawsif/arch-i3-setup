#!/bin/bash

# Color codes
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# Log the installation process
LOGFILE=~/setup.log
exec > >(tee -a $LOGFILE) 2>&1
echo -e "${BLUE}Logging to $LOGFILE${NC}"

# Helper function for error handling
run_or_fail() {
    "$@" || { echo -e "${RED}Error: Failed to execute $@${NC}"; exit 1; }
}

# Update system and install brightnessctl
echo -e "${YELLOW}Updating system and installing brightnessctl...${NC}"
run_or_fail sudo pacman -Syu --noconfirm --needed git base-devel brightnessctl

# Set brightness to 1%
echo -e "${YELLOW}Setting brightness to 1%...${NC}"
run_or_fail sudo brightnessctl set 1%

# Install AUR helper (yay)
if ! command -v yay &>/dev/null; then
    echo -e "${YELLOW}Installing yay AUR helper...${NC}"
    run_or_fail git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    run_or_fail makepkg -si --noconfirm -C /tmp/yay-bin
    rm -rf /tmp/yay-bin
else
    echo -e "${GREEN}yay is already installed.${NC}"
fi

# Function to install packages via pacman or yay
install_pkg() {
    echo -e "${YELLOW}Installing $1...${NC}"
    if [[ "$2" == "yay" ]]; then
        run_or_fail yay -S --noconfirm "$1"
    else
        run_or_fail sudo pacman -S --noconfirm "$1"
    fi
}

# Grouped package installations
echo -e "${YELLOW}Installing essential packages...${NC}"
install_pkg "neofetch curl wget xss-lock bluez bluez-utils blueman lxappearance btop man-db xfce4-terminal thunar thunar-volman thunar-archive-plugin xarchiver gvfs vlc feh zathura zathura-pdf-poppler flameshot dunst rofi code mousepad gnome-themes-standard papirus-icon-theme ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji"

# AUR packages installation
echo -e "${YELLOW}Installing AUR packages...${NC}"
install_pkg "brave-bin" "yay"
install_pkg "freedownloadmanager" "yay"
install_pkg "tkpacman" "yay"

# Enable and start Bluetooth service
echo -e "${YELLOW}Enabling and starting Bluetooth service...${NC}"
run_or_fail sudo systemctl enable --now bluetooth

# Copy configuration files
echo -e "${YELLOW}Copying configuration files...${NC}"
run_or_fail sudo cp 40-libinput.conf /etc/X11/xorg.conf.d/
run_or_fail cp .i3status.conf ~/.i3status.conf
run_or_fail cp -r config.d ~/.config/i3
run_or_fail cp config ~/.config/i3/config
run_or_fail cp .bashrc ~
# Create necessary directories in the home directory
echo -e "${YELLOW}Creating necessary directories in the home directory...${NC}"
run_or_fail mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Music ~/Videos ~/Projects

# Clean up package cache
echo -e "${YELLOW}Cleaning up package cache...${NC}"
run_or_fail sudo pacman -Sc --noconfirm

# Post-installation message
echo -e "${GREEN}Setup completed successfully! Remember to reboot your system.${NC}"
