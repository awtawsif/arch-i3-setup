#!/bin/bash

# Define color codes for text formatting
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Backup directory
BACKUP_DIR=~/config_backups/$(date +%Y%m%d_%H%M%S)

# Log the installation process to a file with timestamp
LOGFILE=~/setup_$(date +%Y%m%d_%H%M%S).log
mkdir -p "$(dirname "$LOGFILE")"
exec > >(tee -a "$LOGFILE") 2>&1

# Print banner
echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════╗"
echo "║         System Setup Installation         ║"
echo "╚═══════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "${BLUE}Logging the installation process to $LOGFILE${NC}"

# Function to check if script is run as root
check_not_root() {
    if [ "$(id -u)" = "0" ]; then
        echo -e "${RED}This script should not be run as root${NC}"
        exit 1
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to backup existing configurations
backup_configs() {
    echo -e "${YELLOW}Creating backup of existing configurations...${NC}"
    mkdir -p "$BACKUP_DIR"
    
    # List of files/directories to backup
    local configs=(
        ~/.config/i3
        ~/.config/rofi
        ~/.bumblebee-status.conf
        ~/.bashrc
        ~/.config/nano/nanorc
    )
    
    for config in "${configs[@]}"; do
        if [ -e "$config" ]; then
            cp -r "$config" "$BACKUP_DIR/" 2>/dev/null || {
                echo -e "${RED}Failed to backup ${config}${NC}"
                return 1
            }
        fi
    done
    
    echo -e "${GREEN}Backup created at: $BACKUP_DIR${NC}"
    return 0
}

# Function to check internet connectivity
check_internet() {
    echo -e "${YELLOW}Checking internet connection...${NC}"
    if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        echo -e "${RED}No internet connection. Please connect to the internet and try again.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Internet connection verified.${NC}"
}

# Function to check system requirements
check_system() {
    echo -e "${YELLOW}Checking system requirements...${NC}"
    
    # Check if running on Arch Linux
    if [ ! -f /etc/arch-release ]; then
        echo -e "${RED}This script is designed for Arch Linux${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}System requirements met.${NC}"
}

# Function to check if files exist before copying
check_files() {
    local missing_files=()
    for file in "$@"; do
        if [ ! -e "$file" ]; then
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -ne 0 ]; then
        echo -e "${RED}Error: The following required files are missing:${NC}"
        printf '%s\n' "${missing_files[@]}"
        return 1
    fi
    return 0
}

# Function to handle errors
handle_error() {
    local exit_code=$?
    local error_msg="$1"
    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Error: $error_msg (Exit code: $exit_code)${NC}"
        echo -e "${YELLOW}Check the log file for more details: $LOGFILE${NC}"
        exit $exit_code
    fi
}

# Function for progress animation
show_progress() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while ps -p $pid > /dev/null; do
        local temp=${spinstr#?}
        printf " [%c] " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Function to install AUR packages with error handling
install_aur_package() {
    local package=$1
    if ! command_exists yay; then
        echo -e "${RED}yay is not installed. Cannot install AUR package.${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Installing $package from AUR...${NC}"
    if ! yay -S --noconfirm "$package"; then
        echo -e "${RED}Failed to install $package${NC}"
        return 1
    fi
    return 0
}

# Main installation function
main() {
    # Initial checks
    check_not_root
    check_internet
    check_system
    
    # Create timestamp for this installation
    local TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    echo -e "${BLUE}Installation started at: $(date)${NC}"
    
    # Backup existing configurations
    backup_configs || {
        echo -e "${RED}Failed to create backup. Exiting...${NC}"
        exit 1
    }
    
    # Verify required files
    echo -e "${YELLOW}Checking for required configuration files...${NC}"
    if ! check_files \
        "40-libinput.conf" \
        "rofi" \
        ".bumblebee-status.conf" \
        "config.d" \
        "config" \
        ".bashrc" \
        "Wallpapers" \
        "scripts" \
        "nanorc"; then
        echo -e "${RED}Missing required files. Please ensure all configuration files are present.${NC}"
        exit 1
    fi
    
    # Git configuration
    echo -e "${YELLOW}Do you want to configure Git with your username and email? (y/n)${NC}"
    read -r configure_git
    
    if [[ "$configure_git" == "y" || "$configure_git" == "Y" ]]; then
        echo -e "${YELLOW}Please enter your GitHub username:${NC}"
        read -r github_username
        echo -e "${YELLOW}Please enter your GitHub email:${NC}"
        read -r github_email
        
        git config --global user.name "$github_username"
        git config --global user.email "$github_email"
        echo -e "${GREEN}Git configured for user: $github_username${NC}"
    else
        echo -e "${YELLOW}Skipping Git configuration as per user choice.${NC}"
    fi
    
    # System update and package installation
    echo -e "${YELLOW}Updating system and installing packages...${NC}"
    {
        sudo pacman -Syu --noconfirm --needed \
            git \
            base-devel \
            brightnessctl \
            nano-syntax-highlighting \
            python-i3ipc \
            mousepad \
            noto-fonts-emoji \
            bash-completion \
            zip \
            unzip \
            neofetch \
            curl \
            wget \
            xss-lock \
            bluez \
            bluez-utils \
            blueman \
            lxappearance \
            man-db \
            thunar \
            thunar-volman \
            thunar-archive-plugin \
            xarchiver \
            gvfs \
            gvfs-mtp \
            hsetroot \
            flameshot \
            dunst \
            rofi \
            i3status-rust \
            ttf-font-awesome \
            gnome-themes-standard \
            papirus-icon-theme
    } &
    show_progress $!
    handle_error "Failed to install packages"
    
    # Set screen brightness
    echo -e "${YELLOW}Setting screen brightness to 3%...${NC}"
    sudo brightnessctl set 3% || handle_error "Failed to set brightness"
    
    # Install yay if not present
    if ! command_exists yay; then
        echo -e "${YELLOW}Installing yay AUR helper...${NC}"
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin || handle_error "Failed to clone yay"
        (cd /tmp/yay-bin && makepkg -si --noconfirm) || handle_error "Failed to install yay"
        rm -rf /tmp/yay-bin
    fi
    
    # Enable services
    echo -e "${YELLOW}Enabling system services...${NC}"
    sudo systemctl enable --now bluetooth || handle_error "Failed to enable bluetooth"
    
    # Create directories
    echo -e "${YELLOW}Creating directory structure...${NC}"
    mkdir -p \
        ~/Documents \
        ~/Downloads \
        ~/Pictures \
        ~/Music \
        ~/Videos \
        ~/Projects \
        ~/.config/i3 \
        ~/.config/nano
    
    # Copy configuration files
    echo -e "${YELLOW}Copying configuration files...${NC}"
    sudo cp 40-libinput.conf /etc/X11/xorg.conf.d/ || handle_error "Failed to copy 40-libinput.conf"
    cp -r rofi ~/.config/ || handle_error "Failed to copy rofi config"
    cp .bumblebee-status.conf ~/ || handle_error "Failed to copy bumblebee-status config"
    cp -r config.d ~/.config/i3/ || handle_error "Failed to copy i3 config.d"
    cp config ~/.config/i3/ || handle_error "Failed to copy i3 config"
    cp .bashrc ~/ || handle_error "Failed to copy bashrc"
    cp -r Wallpapers ~/Pictures/ || handle_error "Failed to copy wallpapers"
    cp -r scripts ~/.config/ || handle_error "Failed to copy scripts"
    cp nanorc ~/.config/nano/ || handle_error "Failed to copy nano config"
    
    # Set permissions
    chmod +x ~/.config/scripts/set_random_wallpaper.sh || handle_error "Failed to set script permissions"
    
    # Clean up
    echo -e "${YELLOW}Cleaning up...${NC}"
    sudo pacman -Sc --noconfirm || handle_error "Failed to clean package cache"
    sudo rm -r .bash_profile
    
    # Installation complete
    echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         Installation Complete!            ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}Installation log: $LOGFILE${NC}"
    echo -e "${YELLOW}Backup directory: $BACKUP_DIR${NC}"
    echo -e "${CYAN}Please reboot your system to apply all changes.${NC}"
}

# Run main function
main "$@"