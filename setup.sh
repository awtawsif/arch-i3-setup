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

# Update system and install dependencies
echo -e "${YELLOW}Updating system and installing base-devel...${NC}"
run_or_fail sudo pacman -Syu --noconfirm --needed git base-devel

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

# Install essential system utilities
install_pkg "neofetch curl wget xss-lock"
install_pkg "bluez bluez-utils blueman"
install_pkg "brightnessctl lxappearance"
install_pkg "btop"

# Install terminal emulator and file manager
install_pkg "xfce4-terminal"
install_pkg "thunar thunar-volman thunar-archive-plugin xarchiver gvfs"

# Install web browser and download manager
install_pkg "brave-bin" "yay"
install_pkg "freedownloadmanager" "yay"

# Install media and image viewers
install_pkg "vlc"
install_pkg "feh"
install_pkg "zathura zathura-pdf-poppler"

# Install screenshot tool, notification daemon, and Rofi launcher
install_pkg "flameshot"
install_pkg "dunst"
install_pkg "rofi"

# Install code editor and text editor
install_pkg "code"
install_pkg "mousepad"

# Install themes and fonts
install_pkg "gnome-themes-standard papirus-icon-theme"
install_pkg "ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji"

# Install tkpacman (AUR package manager front-end)
install_pkg "tkpacman" "yay"

# Enable and start Bluetooth service
echo -e "${YELLOW}Enabling and starting Bluetooth service...${NC}"
run_or_fail sudo systemctl enable bluetooth
run_or_fail sudo systemctl start bluetooth

# Copy configuration files
echo -e "${YELLOW}Copying configuration files...${NC}"
run_or_fail sudo cp 40-libinput.conf /etc/X11/xorg.conf.d/
run_or_fail cp .i3status.conf ~/.i3status.conf
run_or_fail cp -r config.d ~/.config/i3
run_or_fail cp config ~/.config/i3/config

# Create necessary directories in the home directory
echo -e "${YELLOW}Creating necessary directories in the home directory...${NC}"
run_or_fail mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Music ~/Videos ~/Projects

# Clean up package cache
echo -e "${YELLOW}Cleaning up package cache...${NC}"
run_or_fail sudo pacman -Sc --noconfirm

# Post-installation message
echo -e "${GREEN}Setup completed successfully! Remember to reboot your system.${NC}"
