#!/bin/bash

# Define color codes for text formatting
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Define package groups
CORE_PACKAGES=(
    exa
    bat
    base-devel
    stow
    alacritty
    brightnessctl
    nano
    nano-syntax-highlighting
    mousepad
    bash-completion
    i3-wm
    i3blocks
    xorg-xinit
    xorg-xauth
    xorg-server
)

ARCHIVE_PACKAGES=(
    unrar
    zip
    unzip
    xarchiver
)

SYSTEM_PACKAGES=(
    neofetch
    xss-lock
    bluez
    bluez-utils
    blueman
    lxappearance
    man-db
    ly
)

FILE_MANAGER_PACKAGES=(
    thunar
    thunar-volman
    thunar-archive-plugin
    gvfs
    gvfs-mtp
)

UI_PACKAGES=(
    hsetroot
    flameshot
    dunst
    rofi
    i3status-rust
)

THEME_PACKAGES=(
    ttf-jetbrains-mono-nerd
    gnome-themes-standard
    papirus-icon-theme
)

# Parse command line arguments
FORCE_MODE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE_MODE=true
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

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

if [ "$FORCE_MODE" = true ]; then
    echo -e "${YELLOW}Running in force mode - skipping file and directory checks${NC}"
fi

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

# Function to check internet connectivity
check_internet() {
    echo -e "${YELLOW}Checking internet connection...${NC}"
    if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        echo -e "${RED}No internet connection. Please connect to the internet and try again.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Internet connection verified.${NC}"
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

# Function to check required files and directories
check_requirements() {
    if [ "$FORCE_MODE" = true ]; then
        echo -e "${YELLOW}Skipping requirements check due to force mode${NC}"
        return 0
    fi

    # Verify we're in the correct directory
    if [ ! -f "./setup.sh" ]; then
        echo -e "${RED}Please run this script from the i3-wm directory${NC}"
        exit 1
    fi
    
    # Check for required files and directories
    local required_files=("40-libinput.conf" "setup.sh" ".bashrc")
    local required_dirs=("Wallpapers" ".config")
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            echo -e "${RED}Required file '$file' not found!${NC}"
            exit 1
        fi
    done
    
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            echo -e "${RED}Required directory '$dir' not found!${NC}"
            exit 1
        fi
    done
}

# Main installation function
main() {
    # Initial checks
    check_not_root
    check_internet
    check_requirements
    
    # Create timestamp for this installation
    local TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    echo -e "${BLUE}Installation started at: $(date)${NC}"

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
    
    # Install yay if not present
    if ! command_exists yay; then
        echo -e "${YELLOW}Installing yay AUR helper...${NC}"
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin || handle_error "Failed to clone yay"
        (cd /tmp/yay-bin && makepkg -si --noconfirm) || handle_error "Failed to install yay"
        rm -rf /tmp/yay-bin
    fi
    
    # System update and package installation
    echo -e "${YELLOW}Updating system and installing packages...${NC}"
    {
        # Update system first
        sudo pacman -Syu --noconfirm || handle_error "System update failed"
        
        # Install packages by groups
        echo -e "${BLUE}Installing core packages...${NC}"
        sudo pacman -S --noconfirm --needed "${CORE_PACKAGES[@]}" || handle_error "Core packages installation failed"
        
        echo -e "${BLUE}Installing archive tools...${NC}"
        sudo pacman -S --noconfirm --needed "${ARCHIVE_PACKAGES[@]}" || handle_error "Archive packages installation failed"
        
        echo -e "${BLUE}Installing system packages...${NC}"
        sudo pacman -S --noconfirm --needed "${SYSTEM_PACKAGES[@]}" || handle_error "System packages installation failed"
        
        echo -e "${BLUE}Installing file manager packages...${NC}"
        sudo pacman -S --noconfirm --needed "${FILE_MANAGER_PACKAGES[@]}" || handle_error "File manager packages installation failed"
        
        echo -e "${BLUE}Installing UI packages...${NC}"
        sudo pacman -S --noconfirm --needed "${UI_PACKAGES[@]}" || handle_error "UI packages installation failed"
        
        echo -e "${BLUE}Installing theme packages...${NC}"
        sudo pacman -S --noconfirm --needed "${THEME_PACKAGES[@]}" || handle_error "Theme packages installation failed"
    } &
    show_progress $!
    
    # Set screen brightness with error handling
    echo -e "${YELLOW}Setting screen brightness to 3%...${NC}"
    if ! sudo brightnessctl set 3%; then
        echo -e "${YELLOW}Warning: Failed to set brightness, continuing anyway...${NC}"
    fi
    
    # Enable services with error handling
    echo -e "${YELLOW}Enabling system services...${NC}"
    if ! sudo systemctl enable bluetooth; then
        echo -e "${YELLOW}Warning: Failed to enable bluetooth service, continuing anyway...${NC}"
    fi
    
    echo -e "${YELLOW}Enabling ly display manager service...${NC}"
    if ! sudo systemctl enable ly.service; then
        echo -e "${RED}Failed to enable ly service.${NC}"
        exit 1
    fi
    
    # Create directories
    echo -e "${YELLOW}Creating directory structure...${NC}"
    mkdir -p \
        ~/Documents \
        ~/Downloads \
        ~/Pictures \
        ~/Music \
        ~/Videos \
        ~/Projects
    
    # Copy configuration files
    echo -e "${YELLOW}Copying configuration files...${NC}"
    sudo mkdir -p /etc/X11/xorg.conf.d/
    sudo cp 40-libinput.conf /etc/X11/xorg.conf.d/ || handle_error "Failed to copy 40-libinput.conf"
    cp .bashrc ~/ || handle_error "Failed to copy bash config"
    cp -r Wallpapers ~/Pictures/ || handle_error "Failed to copy wallpapers"
    cp -rb .config ~/ || handle_error "Failed to copy config files"
    
    # Set permissions
    chmod +x ~/Pictures/Wallpapers/set_random_wallpaper.sh || handle_error "Failed to set script permissions"
    
    # Clean up
    echo -e "${YELLOW}Cleaning up...${NC}"
    sudo pacman -Sc --noconfirm || handle_error "Failed to clean package cache"
    
    # Remove bash_profile if it exists
    rm -f ~/.bash_profile
    
    # Installation complete
    echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         Installation Complete!            ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}Installation log: $LOGFILE${NC}"
    echo -e "${CYAN}Please reboot your system to apply all changes.${NC}"
}

# Run main function
main "$@"