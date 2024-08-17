#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Update system and install dependencies
echo "Updating system and installing base-devel..."
pacman -Syu --noconfirm --needed git base-devel

# Install AUR helper (yay)
if ! command -v yay &>/dev/null; then
    echo "Installing yay AUR helper..."
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay-bin
else
    echo "yay is already installed."
fi

# Install Web Browser
echo "Installing Brave browser..."
yay -S --noconfirm brave-bin

# Install Download Manager
echo "Installing FDM..."
yay -S --noconfirm freedownloadmanager

# Install Code Editor
echo "Installing Visual Studio Code..."
pacman -S --noconfirm code

# Install and set up File Manager
echo "Installing Thunar and related plugins..."
pacman -S --noconfirm thunar thunar-volman thunar-archive-plugin xarchiver gvfs

# Install a lightweight text editor
echo "Installing Mousepad..."
pacman -S --noconfirm mousepad

# Install display brightness and appearance management tools
echo "Installing brightnessctl and lxappearance..."
pacman -S --noconfirm brightnessctl lxappearance

# Install terminal emulator (xfce4-terminal instead of alacritty)
echo "Installing XFCE4 Terminal..."
pacman -S --noconfirm xfce4-terminal

# Install Media Players
echo "Installing VLC media player..."
pacman -S --noconfirm vlc

# Install Image Viewer
echo "Installing feh image viewer..."
pacman -S --noconfirm feh

# Install Screenshot tool
echo "Installing flameshot screenshot tool..."
pacman -S --noconfirm flameshot

# Install a PDF Viewer
echo "Installing Zathura PDF viewer..."
pacman -S --noconfirm zathura zathura-pdf-poppler

# Install Fonts
echo "Installing commonly used fonts..."
pacman -S --noconfirm ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji

# Install utilities
echo "Installing utilities (neofetch, curl, wget)..."
pacman -S --noconfirm neofetch curl wget

# Install Bluetooth support
echo "Installing Bluetooth support..."
pacman -S --noconfirm bluez bluez-utils blueman
systemctl enable bluetooth
systemctl start bluetooth

# Install Rofi (replacement for dmenu)
echo "Installing Rofi application launcher..."
pacman -S --noconfirm rofi

# Install dark themes and icon themes
echo "Installing dark themes and icon themes..."
pacman -S --noconfirm gnome-themes-standard papirus-icon-theme

# Copy .i3status.conf to the home directory
echo "Copying .i3status.conf to the home directory..."
cp .i3status.conf ~/.i3status.conf

# Replace the default i3 config file with your custom one
echo "Replacing the default i3 config file with your custom i3config file..."
I3_CONFIG_DIR=~/.config/i3
I3_CONFIG_FILE=$I3_CONFIG_DIR/config

# Remove the existing i3 config file
rm -f $I3_CONFIG_FILE

# Copy your custom i3config file to the i3 config directory
cp i3config $I3_CONFIG_FILE

# Copy the config.d folder to the i3 config directory
echo "Copying the config.d folder to the i3 config directory..."
cp -r config.d ~/.config/i3/

echo "Setup completed successfully!"
