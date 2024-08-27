#!/bin/bash

# Define color codes for text formatting
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# Log the installation process to a file
LOGFILE=~/setup.log
exec > >(tee -a $LOGFILE) 2>&1
echo -e "${BLUE}Logging the installation process to $LOGFILE${NC}"

# Step 1: Update the system, install essential tools and git setup
echo -e "${YELLOW}Step 1: Updating system and installing brightnessctl...${NC}"
sudo pacman -Syu --noconfirm --needed git base-devel brightnessctl
git config --global user.name "Tawsif"
git config --global user.email tawsif7492@gmail.com
echo -e "${GREEN}System updated and brightnessctl installed.${NC}"

# Step 2: Set screen brightness to 3%
echo -e "${YELLOW}Step 2: Setting screen brightness to 3%...${NC}"
sudo brightnessctl set 3%
echo -e "${GREEN}Screen brightness set to 3%.${NC}"

# Step 3: Install yay AUR helper if it's not already installed
echo -e "${YELLOW}Step 3: Installing yay AUR helper...${NC}"
command -v yay &>/dev/null
echo -e "${GREEN}yay is already installed.${NC}"
echo -e "${YELLOW}Cloning yay AUR helper...${NC}"
git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
echo -e "${YELLOW}Building and installing yay AUR helper...${NC}"
cd /tmp/yay-bin
makepkg -si --noconfirm
cd -
rm -rf /tmp/yay-bin
echo -e "${GREEN}yay AUR helper installed.${NC}"

# Step 5: Install essential packages
echo -e "${YELLOW}Step 5: Installing essential packages...${NC}"
sudo pacman -S --noconfirm neofetch curl wget xss-lock bluez bluez-utils blueman lxappearance man-db thunar thunar-volman thunar-archive-plugin xarchiver gvfs gvfs-mtp feh flameshot dunst rofi gnome-themes-standard papirus-icon-theme
echo -e "${GREEN}Essential packages installed.${NC}"

# Step 6: Install AUR packages using yay
echo -e "${YELLOW}Step 6: Installing AUR packages with yay...${NC}"
yay -S --noconfirm thorium-browser-bin
yay -S --noconfirm visual-studio-code-bin
yay -S --noconfirm tkpacman
echo -e "${GREEN}AUR packages installed.${NC}"

# Step 7: Enable and start the Bluetooth service
echo -e "${YELLOW}Step 7: Enabling and starting Bluetooth service...${NC}"
sudo systemctl enable --now bluetooth
echo -e "${GREEN}Bluetooth service enabled and started.${NC}"

# Step 8: Copy configuration files
echo -e "${YELLOW}Step 8: Copying configuration files...${NC}"
sudo cp 40-libinput.conf /etc/X11/xorg.conf.d/
cp .i3status.conf ~/.i3status.conf
cp -r config.d ~/.config/i3
cp config ~/.config/i3/config
cp .bashrc ~
echo -e "${GREEN}Configuration files copied.${NC}"

# Step 9: Create necessary directories in the home directory
echo -e "${YELLOW}Step 9: Creating necessary directories in the home directory...${NC}"
mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Music ~/Videos ~/Projects
echo -e "${GREEN}Directories created.${NC}"

# Step 10: Clean up package cache
echo -e "${YELLOW}Step 10: Cleaning up package cache...${NC}"
sudo pacman -Sc --noconfirm
echo -e "${GREEN}Package cache cleaned.${NC}"

# Step 11: Post-installation message
echo -e "${GREEN}Setup completed successfully! Remember to reboot your system.${NC}"
