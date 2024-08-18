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

# Step 1: Update the system and install essential tools
echo -e "${YELLOW}Step 1: Updating system and installing brightnessctl...${NC}"
sudo pacman -Syu --noconfirm --needed git base-devel brightnessctl
echo -e "${GREEN}System updated and brightnessctl installed.${NC}"

# Step 2: Set screen brightness to 1%
echo -e "${YELLOW}Step 2: Setting screen brightness to 1%...${NC}"
sudo brightnessctl set 1%
echo -e "${GREEN}Screen brightness set to 1%.${NC}"

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

# Step 4: Install essential packages
echo -e "${YELLOW}Step 4: Installing essential packages...${NC}"
sudo pacman -S --noconfirm timeshift neofetch curl wget xss-lock bluez bluez-utils blueman lxappearance btop man-db xfce4-terminal thunar thunar-volman thunar-archive-plugin xarchiver gvfs feh flameshot dunst rofi mousepad gnome-themes-standard papirus-icon-theme ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji
echo -e "${GREEN}Essential packages installed.${NC}"

# Step 5: Install AUR packages using yay
echo -e "${YELLOW}Step 5: Installing AUR packages with yay...${NC}"
yay -S --noconfirm brave-bin
yay -S --noconfirm visual-studio-code-bin
yay -S --noconfirm tkpacman
echo -e "${GREEN}AUR packages installed.${NC}"

# Step 6: Enable and start the Bluetooth service
echo -e "${YELLOW}Step 6: Enabling and starting Bluetooth service...${NC}"
sudo systemctl enable --now bluetooth
echo -e "${GREEN}Bluetooth service enabled and started.${NC}"

# Step 7: Copy configuration files
echo -e "${YELLOW}Step 7: Copying configuration files...${NC}"
sudo cp 40-libinput.conf /etc/X11/xorg.conf.d/
cp .i3status.conf ~/.i3status.conf
cp -r config.d ~/.config/i3
cp config ~/.config/i3/config
echo -e "${GREEN}Configuration files copied.${NC}"

# Step 8: Create necessary directories in the home directory
echo -e "${YELLOW}Step 8: Creating necessary directories in the home directory...${NC}"
mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Music ~/Videos ~/Projects
echo -e "${GREEN}Directories created.${NC}"

# Step 9: Clean up package cache
echo -e "${YELLOW}Step 9: Cleaning up package cache...${NC}"
sudo pacman -Sc --noconfirm
echo -e "${GREEN}Package cache cleaned.${NC}"

# Step 10: Post-installation message
echo -e "${GREEN}Setup completed successfully! Remember to reboot your system.${NC}"
