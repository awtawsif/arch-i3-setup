#!/bin/bash

# Define color codes for text formatting
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Define backup directory
BACKUP_DIR="$HOME/.config_backups/$(date +%Y%m%d_%H%M%S)"

# Improve package grouping with descriptions and dependencies
declare -A PACKAGE_GROUPS
PACKAGE_GROUPS=(
    ["core"]="Essential system components|htop exa bat alacritty brightnessctl nano nano-syntax-highlighting mousepad bash-completion i3-wm i3blocks"
    ["archive"]="Archive management tools|unrar zip unzip xarchiver"
    ["system"]="System utilities and services|fastfetch xss-lock bluez bluez-utils blueman lxappearance man-db ly network-manager-applet upower"
    ["file_manager"]="File management tools|thunar thunar-volman thunar-archive-plugin gvfs gvfs-mtp"
    ["ui"]="User interface components|feh flameshot dunst rofi i3status-rust tumbler"
    ["theme"]="Theming and fonts|ttf-font-awesome ttf-jetbrains-mono-nerd noto-fonts-emoji gnome-themes-standard papirus-icon-theme"
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

# Add new functions for improved functionality
backup_configs() {
    echo -e "${YELLOW}Creating backup of existing configs...${NC}"
    mkdir -p "$BACKUP_DIR"
    if [ -d "$HOME/.config" ]; then
        cp -r "$HOME/.config" "$BACKUP_DIR/"
    fi
    if [ -f "$HOME/.bashrc" ]; then
        cp "$HOME/.bashrc" "$BACKUP_DIR/"
    fi
}

restore_backup() {
    if [ -d "$BACKUP_DIR" ]; then
        echo -e "${YELLOW}Restoring configurations from backup...${NC}"
        cp -r "$BACKUP_DIR/.config" "$HOME/" 2>/dev/null
        cp "$BACKUP_DIR/.bashrc" "$HOME/" 2>/dev/null
    fi
}

verify_packages() {
    local group=$1
    local packages=(${PACKAGE_GROUPS[$group]#*|})
    
    echo -e "${YELLOW}Verifying packages for group '$group'...${NC}"
    for pkg in "${packages[@]}"; do
        if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
            return 1
        fi
    done
    return 0
}

install_package_group() {
    local group=$1
    local description=${PACKAGE_GROUPS[$group]%%|*}
    local packages=(${PACKAGE_GROUPS[$group]#*|})
    
    echo -e "${BLUE}Installing $group packages ($description)...${NC}"
    if ! sudo pacman -S --noconfirm --needed "${packages[@]}"; then
        handle_error "Failed to install $group packages"
        return 1
    fi
    return 0
}

# Main installation function
main() {
    check_not_root
    check_internet
    check_requirements

    # Create backup of existing configs
    backup_configs

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

    # Install AUR packages
    AUR_PACKAGES=(
        i3lock-color
        # Add more AUR packages here
    )

    echo -e "${YELLOW}Installing AUR packages...${NC}"
    for package in "${AUR_PACKAGES[@]}"; do
        install_aur_package "$package" || handle_error "Failed to install AUR package: $package"
    done

    # Browser selection and installation
    echo -e "${YELLOW}Select a browser to install:${NC}"
    echo "1) Firefox"
    echo "2) Chromium"
    echo "3) Brave (AUR)"
    echo "4) Skip"
    read -rp "Enter your choice [1-4]: " browser_choice

    case $browser_choice in
        1)
            echo -e "${YELLOW}Installing Firefox...${NC}"
            sudo pacman -S --noconfirm firefox || handle_error "Failed to install Firefox"
            ;;
        2)
            echo -e "${YELLOW}Installing Chromium...${NC}"
            sudo pacman -S --noconfirm chromium || handle_error "Failed to install Chromium"
            ;;
        3)
            echo -e "${YELLOW}Installing Brave from AUR...${NC}"
            install_aur_package brave-bin || handle_error "Failed to install Brave"
            ;;
        4)
            echo -e "${YELLOW}Skipping browser installation.${NC}"
            ;;
        *)
            echo -e "${RED}Invalid choice. Skipping browser installation.${NC}"
            ;;
    esac

    # Install packages using new group structure
    for group in "${!PACKAGE_GROUPS[@]}"; do
        install_package_group "$group" || {
            echo -e "${RED}Failed to install $group packages. Rolling back...${NC}"
            restore_backup
            exit 1
        }
    done

    # Verify installations
    echo -e "${YELLOW}Verifying installations...${NC}"
    for group in "${!PACKAGE_GROUPS[@]}"; do
        verify_packages "$group" || {
            echo -e "${RED}Package verification failed for group $group${NC}"
            restore_backup
            exit 1
        }
    done

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

    # Add configuration validation
    echo -e "${YELLOW}Validating configurations...${NC}"
    if ! i3 -C; then
        echo -e "${RED}i3 configuration validation failed. Rolling back...${NC}"
        restore_backup
        exit 1
    fi

    # Installation complete
    echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         Installation Complete!            ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}Installation log: $LOGFILE${NC}"
    echo -e "${CYAN}Please reboot your system to apply all changes.${NC}"
}

# Add cleanup trap
trap 'echo -e "${RED}Installation interrupted. Rolling back...${NC}"; restore_backup; exit 1' INT TERM

# Run main function with arguments
main "$@"
