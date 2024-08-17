#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Log the installation process
LOGFILE=~/setup.log
exec > >(tee -a $LOGFILE) 2>&1
echo "Logging to $LOGFILE"

# Update system and install dependencies
echo "Updating system and installing base-devel..."
if ! pacman -Syu --noconfirm --needed git base-devel; then
    echo "Failed to update the system and install base-devel."
    exit 1
fi

# Install AUR helper (yay)
if ! command -v yay &>/dev/null; then
    echo "Installing yay AUR helper..."
    if ! git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin; then
        echo "Failed to clone yay-bin repository."
        exit 1
    fi
    cd /tmp/yay-bin
    if ! makepkg -si --noconfirm; then
        echo "Failed to build and install yay."
        exit 1
    fi
    cd ~
    rm -rf /tmp/yay-bin
else
    echo "yay is already installed."
fi

# Install Web Browser
echo "Installing Brave browser..."
if ! yay -S --noconfirm brave-bin; then
    echo "Failed to install Brave browser."
    exit 1
fi

# Install Download Manager
echo "Installing FDM..."
if ! yay -S --noconfirm freedownloadmanager; then
    echo "Failed to install FDM."
    exit 1
fi

# Install Code Editor
echo "Installing Visual Studio Code..."
if ! pacman -S --noconfirm code; then
    echo "Failed to install Visual Studio Code."
    exit 1
fi

# Install and set up File Manager
echo "Installing Thunar and related plugins..."
if ! pacman -S --noconfirm thunar thunar-volman thunar-archive-plugin xarchiver gvfs; then
    echo "Failed to install Thunar and related plugins."
    exit 1
fi

# Install a lightweight text editor
echo "Installing Mousepad..."
if ! pacman -S --noconfirm mousepad; then
    echo "Failed to install Mousepad."
    exit 1
fi

# Install display brightness and appearance management tools
echo "Installing brightnessctl and lxappearance..."
if ! pacman -S --noconfirm brightnessctl lxappearance; then
    echo "Failed to install brightnessctl and lxappearance."
    exit 1
fi

# Install terminal emulator (xfce4-terminal instead of alacritty)
echo "Installing XFCE4 Terminal..."
if ! pacman -S --noconfirm xfce4-terminal; then
    echo "Failed to install XFCE4 Terminal."
    exit 1
fi

# Install Media Players
echo "Installing VLC media player..."
if ! pacman -S --noconfirm vlc; then
    echo "Failed to install VLC media player."
    exit 1
fi

# Install Image Viewer
echo "Installing feh image viewer..."
if ! pacman -S --noconfirm feh; then
    echo "Failed to install feh image viewer."
    exit 1
fi

# Install Screenshot tool
echo "Installing flameshot screenshot tool..."
if ! pacman -S --noconfirm flameshot; then
    echo "Failed to install flameshot."
    exit 1
fi

# Install a PDF Viewer
echo "Installing Zathura PDF viewer..."
if ! pacman -S --noconfirm zathura zathura-pdf-poppler; then
    echo "Failed to install Zathura PDF viewer."
    exit 1
fi

# Install Fonts
echo "Installing commonly used fonts..."
if ! pacman -S --noconfirm ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji; then
    echo "Failed to install fonts."
    exit 1
fi

# Install utilities
echo "Installing utilities (neofetch, curl, wget)..."
if ! pacman -S --noconfirm neofetch curl wget; then
    echo "Failed to install utilities."
    exit 1
fi

# Install Bluetooth support
echo "Installing Bluetooth support..."
if ! pacman -S --noconfirm bluez bluez-utils blueman; then
    echo "Failed to install Bluetooth support."
    exit 1
fi
if ! systemctl enable bluetooth; then
    echo "Failed to enable Bluetooth service."
    exit 1
fi
if ! systemctl start bluetooth; then
    echo "Failed to start Bluetooth service."
    exit 1
fi

# Install Rofi (replacement for dmenu)
echo "Installing Rofi application launcher..."
if ! pacman -S --noconfirm rofi; then
    echo "Failed to install Rofi."
    exit 1
fi

# Install dark themes and icon themes
echo "Installing dark themes and icon themes..."
if ! pacman -S --noconfirm gnome-themes-standard papirus-icon-theme; then
    echo "Failed to install dark themes and icon themes."
    exit 1
fi

# Install notification daemon (dunst)
echo "Installing Dunst notification daemon..."
if ! pacman -S --noconfirm dunst; then
    echo "Failed to install Dunst."
    exit 1
fi

# Copy .i3status.conf to the home directory
echo "Copying .i3status.conf to the home directory..."
if ! cp .i3status.conf ~/.i3status.conf; then
    echo "Failed to copy .i3status.conf."
    exit 1
fi

# Replace the default i3 config file with your custom one
echo "Replacing the default i3 config file with your custom i3config file..."
I3_CONFIG_DIR=~/.config/i3
I3_CONFIG_FILE=$I3_CONFIG_DIR/config

# Remove the existing i3 config file
if ! rm -f $I3_CONFIG_FILE; then
    echo "Failed to remove the existing i3 config file."
    exit 1
fi

# Copy your custom i3config file to the i3 config directory
if ! cp i3config $I3_CONFIG_FILE; then
    echo "Failed to copy the custom i3config file."
    exit 1
fi

# Copy the config.d folder to the i3 config directory
echo "Copying the config.d folder to the i3 config directory..."
if ! cp -r config.d ~/.config/i3/; then
    echo "Failed to copy the config.d folder."
    exit 1
fi

# Create necessary directories in the home directory
echo "Creating necessary directories in the home directory..."
if ! mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Music ~/Videos ~/Projects; then
    echo "Failed to create directories in the home directory."
    exit 1
fi

# Clean up package cache
echo "Cleaning up package cache..."
if ! pacman -Sc --noconfirm; then
    echo "Failed to clean up package cache."
    exit 1
fi

# Post-installation message
echo "Setup completed successfully! Remember to reboot your system."
