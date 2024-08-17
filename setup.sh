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

# Update system and install dependencies
echo -e "${YELLOW}Updating system and installing base-devel...${NC}"
if ! sudo pacman -Syu --noconfirm --needed git base-devel; then
    echo -e "${RED}Failed to update the system and install base-devel.${NC}"
    exit 1
fi

# Install AUR helper (yay)
if ! command -v yay &>/dev/null; then
    echo -e "${YELLOW}Installing yay AUR helper...${NC}"
    if ! git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin; then
        echo -e "${RED}Failed to clone yay-bin repository.${NC}"
        exit 1
    fi
    cd /tmp/yay-bin
    if ! makepkg -si --noconfirm; then
        echo -e "${RED}Failed to build and install yay.${NC}"
        exit 1
    fi
    cd ~
    rm -rf /tmp/yay-bin
else
    echo -e "${GREEN}yay is already installed.${NC}"
fi

# Install Web Browser
echo -e "${YELLOW}Installing Brave browser...${NC}"
if ! yay -S --noconfirm brave-bin; then
    echo -e "${RED}Failed to install Brave browser.${NC}"
    exit 1
fi

# Install Download Manager
echo -e "${YELLOW}Installing FDM...${NC}"
if ! yay -S --noconfirm freedownloadmanager; then
    echo -e "${RED}Failed to install FDM.${NC}"
    exit 1
fi

# Install Code Editor
echo -e "${YELLOW}Installing Visual Studio Code...${NC}"
if ! sudo pacman -S --noconfirm code; then
    echo -e "${RED}Failed to install Visual Studio Code.${NC}"
    exit 1
fi

# Install and set up File Manager
echo -e "${YELLOW}Installing Thunar and related plugins...${NC}"
if ! sudo pacman -S --noconfirm thunar thunar-volman thunar-archive-plugin xarchiver gvfs; then
    echo -e "${RED}Failed to install Thunar and related plugins.${NC}"
    exit 1
fi

# Install a lightweight text editor
echo -e "${YELLOW}Installing Mousepad...${NC}"
if ! sudo pacman -S --noconfirm mousepad; then
    echo -e "${RED}Failed to install Mousepad.${NC}"
    exit 1
fi

# Install display brightness and appearance management tools
echo -e "${YELLOW}Installing brightnessctl and lxappearance...${NC}"
if ! sudo pacman -S --noconfirm brightnessctl lxappearance; then
    echo -e "${RED}Failed to install brightnessctl and lxappearance.${NC}"
    exit 1
fi

# Install terminal emulator (xfce4-terminal instead of alacritty)
echo -e "${YELLOW}Installing XFCE4 Terminal...${NC}"
if ! sudo pacman -S --noconfirm xfce4-terminal; then
    echo -e "${RED}Failed to install XFCE4 Terminal.${NC}"
    exit 1
fi

# Install Media Players
echo -e "${YELLOW}Installing VLC media player...${NC}"
if ! sudo pacman -S --noconfirm vlc; then
    echo -e "${RED}Failed to install VLC media player.${NC}"
    exit 1
fi

# Install Image Viewer
echo -e "${YELLOW}Installing feh image viewer...${NC}"
if ! sudo pacman -S --noconfirm feh; then
    echo -e "${RED}Failed to install feh image viewer.${NC}"
    exit 1
fi

# Install Screenshot tool
echo -e "${YELLOW}Installing flameshot screenshot tool...${NC}"
if ! sudo pacman -S --noconfirm flameshot; then
    echo -e "${RED}Failed to install flameshot.${NC}"
    exit 1
fi

# Install a PDF Viewer
echo -e "${YELLOW}Installing Zathura PDF viewer...${NC}"
if ! sudo pacman -S --noconfirm zathura zathura-pdf-poppler; then
    echo -e "${RED}Failed to install Zathura PDF viewer.${NC}"
    exit 1
fi

# Install Fonts
echo -e "${YELLOW}Installing commonly used fonts...${NC}"
if ! sudo pacman -S --noconfirm ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji; then
    echo -e "${RED}Failed to install fonts.${NC}"
    exit 1
fi

# Install utilities
echo -e "${YELLOW}Installing utilities (neofetch, curl, wget)...${NC}"
if ! sudo pacman -S --noconfirm neofetch curl wget; then
    echo -e "${RED}Failed to install utilities.${NC}"
    exit 1
fi

# Install Bluetooth support
echo -e "${YELLOW}Installing Bluetooth support...${NC}"
if ! sudo pacman -S --noconfirm bluez bluez-utils blueman; then
    echo -e "${RED}Failed to install Bluetooth support.${NC}"
    exit 1
fi
if ! sudo systemctl enable bluetooth; then
    echo -e "${RED}Failed to enable Bluetooth service.${NC}"
    exit 1
fi
if ! sudo systemctl start bluetooth; then
    echo -e "${RED}Failed to start Bluetooth service.${NC}"
    exit 1
fi

# Install Rofi (replacement for dmenu)
echo -e "${YELLOW}Installing Rofi application launcher...${NC}"
if ! sudo pacman -S --noconfirm rofi; then
    echo -e "${RED}Failed to install Rofi.${NC}"
    exit 1
fi

# Install dark themes and icon themes
echo -e "${YELLOW}Installing dark themes and icon themes...${NC}"
if ! sudo pacman -S --noconfirm gnome-themes-standard papirus-icon-theme; then
    echo -e "${RED}Failed to install dark themes and icon themes.${NC}"
    exit 1
fi

# Install notification daemon (dunst)
echo -e "${YELLOW}Installing Dunst notification daemon...${NC}"
if ! sudo pacman -S --noconfirm dunst; then
    echo -e "${RED}Failed to install Dunst.${NC}"
    exit 1
fi

# Install tkpacman (graphical front-end for Pacman)
echo -e "${YELLOW}Installing tkpacman...${NC}"
if ! yay -S --noconfirm tkpacman; then
    echo -e "${RED}Failed to install tkpacman.${NC}"
    exit 1
fi

# Install btop (resource monitor)
echo -e "${YELLOW}Installing btop...${NC}"
if ! sudo pacman -S --noconfirm btop; then
    echo -e "${RED}Failed to install btop.${NC}"
    exit 1
fi

# Copy 40-libinput.conf to /etc/X11/xorg.conf.d/
echo -e "${YELLOW}Copying 40-libinput.conf to /etc/X11/xorg.conf.d/...${NC}"
if ! sudo cp 40-libinput.conf /etc/X11/xorg.conf.d/; then
    echo -e "${RED}Failed to copy 40-libinput.conf.${NC}"
    exit 1
fi

# Copy .i3status.conf to the home directory
echo -e "${YELLOW}Copying .i3status.conf to the home directory...${NC}"
if ! cp .i3status.conf ~/.i3status.conf; then
    echo -e "${RED}Failed to copy .i3status.conf.${NC}"
    exit 1
fi

# Replace the default i3 config file with your custom one
echo -e "${YELLOW}Replacing the default i3 config file with your custom i3config file...${NC}"
I3_CONFIG_DIR=~/.config/i3
I3_CONFIG_FILE=$I3_CONFIG_DIR/config

# Remove the existing i3 config file
if ! rm -f $I3_CONFIG_FILE; then
    echo -e "${RED}Failed to remove the existing i3 config file.${NC}"
    exit 1
fi

# Copy your custom i3config file to the i3 config directory
if ! cp config $I3_CONFIG_FILE; then
    echo -e "${RED}Failed to copy the custom i3config file.${NC}"
    exit 1
fi

# Copy the config.d folder to the i3 config directory
echo -e "${YELLOW}Copying the config.d folder to the i3 config directory...${NC}"
if ! cp -r config.d ~/.config/i3; then
    echo -e "${RED}Failed to copy the config.d folder.${NC}"
    exit 1
fi

# Create necessary directories in the home directory
echo -e "${YELLOW}Creating necessary directories in the home directory...${NC}"
if ! mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Music ~/Videos ~/Projects; then
    echo -e "${RED}Failed to create directories in the home directory.${NC}"
    exit 1
fi

# Clean up package cache
echo -e "${YELLOW}Cleaning up package cache...${NC}"
if ! sudo pacman -Sc --noconfirm; then
    echo -e "${RED}Failed to clean up package cache.${NC}"
    exit 1
fi

# Post-installation message
echo -e "${GREEN}Setup completed successfully! Remember to reboot your system.${NC}"
