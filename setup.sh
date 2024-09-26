#!/bin/bash

# Define color codes for text formatting
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# Log the installation process to a file
LOGFILE=~/setup.log
exec > >(tee -a "$LOGFILE") 2>&1
echo -e "${BLUE}Logging the installation process to $LOGFILE${NC}"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Step 1: Update the system, install essential tools and git setup
echo -e "${YELLOW}Step 1: Updating system and installing brightnessctl...${NC}"
sudo pacman -Syu --noconfirm --needed git base-devel brightnessctl
if [ $? -ne 0 ]; then
    echo -e "${RED}Error updating system or installing brightnessctl. Exiting...${NC}"
    exit 1
fi
git config --global user.name "Tawsif"
git config --global user.email "tawsif7492@gmail.com" # Added quotes for email
echo -e "${GREEN}System updated and brightnessctl installed.${NC}"

# Step 2: Set screen brightness to 3%
echo -e "${YELLOW}Step 2: Setting screen brightness to 3%...${NC}"
sudo brightnessctl set 3%
if [ $? -ne 0 ]; then
    echo -e "${RED}Error setting screen brightness. Exiting...${NC}" # Added error check
    exit 1
fi
echo -e "${GREEN}Screen brightness set to 3%.${NC}"

# Step 3: Install yay AUR helper if it's not already installed
echo -e "${YELLOW}Step 3: Installing yay AUR helper...${NC}"
if command_exists yay; then
    echo -e "${GREEN}yay is already installed, skipping installation.${NC}"
else
    echo -e "${YELLOW}Cloning yay AUR helper...${NC}"
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    echo -e "${YELLOW}Building and installing yay AUR helper...${NC}"
    cd /tmp/yay-bin || exit # Added exit on failure to change directory
    makepkg -si --noconfirm
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error installing yay. Exiting...${NC}"
        exit 1
    fi
    cd - || exit # Added exit on failure to return to the previous directory
    sudo rm -rf /tmp/yay-bin
    echo -e "${GREEN}yay AUR helper installed.${NC}"
fi
# Step 4: Install essential packages
echo -e "${YELLOW}Step 4: Installing essential packages...${NC}"
sudo pacman -S --noconfirm noto-fonts-emoji bash-completion zip unzip neofetch curl wget xss-lock bluez bluez-utils blueman lxappearance man-db thunar thunar-volman thunar-archive-plugin xarchiver gvfs gvfs-mtp hsetroot flameshot dunst rofi gnome-themes-standard papirus-icon-theme
if [ $? -ne 0 ]; then
    echo -e "${RED}Error installing essential packages. Exiting...${NC}"
    exit 1
fi
echo -e "${GREEN}Essential packages installed.${NC}"

# Step 5: Enable and start the Bluetooth service
echo -e "${YELLOW}Step 5: Enabling and starting Bluetooth service...${NC}"
sudo systemctl enable --now bluetooth
if [ $? -ne 0 ]; then
    echo -e "${RED}Error enabling or starting Bluetooth service. Exiting...${NC}"
    exit 1
fi
echo -e "${GREEN}Bluetooth service enabled and started.${NC}"

# Step 6: Create necessary directories in the home directory
echo -e "${YELLOW}Step 6: Creating necessary directories in the home directory...${NC}"
mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Music ~/Videos ~/Projects
echo -e "${GREEN}Directories created.${NC}"

# Step 7: Copy configuration files
echo -e "${YELLOW}Step 7: Copying configuration files...${NC}"
sudo cp 40-libinput.conf /etc/X11/xorg.conf.d/
cp .i3status.conf ~/.i3status.conf
cp -r config.d ~/.config/i3
cp config ~/.config/i3/config
cp .bashrc ~/.bashrc
cp -r Wallpapers ~/Pictures
cp -r scripts ~/.config
chmod +x ~/.config/scripts/set_random_wallpaper.sh
echo -e "${GREEN}Configuration files copied.${NC}"

# Step 8: Clean up package cache
echo -e "${YELLOW}Step 8: Cleaning up package cache...${NC}"
sudo pacman -Sc --noconfirm
echo -e "${GREEN}Package cache cleaned.${NC}"

# Step 9: Post-installation message
echo -e "${GREEN}Setup completed successfully! Remember to reboot your system.${NC}"
