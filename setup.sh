#!/bin/bash

# Script: Arch Linux i3 Setup Script
# Description: Automated setup script for Arch Linux with i3 window manager
# Usage: ./setup.sh [--dry-run] [--skip-packages] [--skip-git] [--skip-backup]
# Requirements: 
#   - Arch Linux base installation
#   - Internet connection
#   - Directory structure as described in README.md

# Define color codes for text formatting
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Configuration variables
BACKUP_DIR=~/config_backups/$(date +%Y%m%d_%H%M%S)
LOGFILE=~/setup_$(date +%Y%m%d_%H%M%S).log
MIN_DISK_SPACE=5120  # Minimum 5GB free space required
CONFIG_FILE="config.yaml"  # Optional: for future use with configuration file

# Package groups
CORE_PACKAGES=(
    "stow"              # Symlink farm manager
    "alacritty"         # Terminal emulator
    "git"               # Version control
    "base-devel"        # Development tools
    "brightnessctl"     # Brightness control
    "python-i3ipc"      # i3 IPC Python library
)

WM_PACKAGES=(
    "i3status-rust"     # Status bar
    "rofi"              # Application launcher
    "dunst"             # Notification daemon
    "hsetroot"          # Wallpaper setter
)

UTILITY_PACKAGES=(
    "mousepad"          # Text editor
    "bash-completion"   # Bash completion
    "zip"               # Compression utility
    "unzip"            # Decompression utility
    "neofetch"         # System information
    "curl"             # URL transfer tool
    "wget"             # File download utility
)

FILE_MANAGER_PACKAGES=(
    "thunar"           # File manager
    "thunar-volman"    # Volume manager
    "thunar-archive-plugin"  # Archive plugin
    "xarchiver"        # Archive manager
    "gvfs"             # Virtual filesystem
    "gvfs-mtp"         # MTP support
)

# Parse command line arguments
DRY_RUN=0
SKIP_PACKAGES=0
SKIP_GIT=0
SKIP_BACKUP=0

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=1
                shift
                ;;
            --skip-packages)
                SKIP_PACKAGES=1
                shift
                ;;
            --skip-git)
                SKIP_GIT=1
                shift
                ;;
            --skip-backup)
                SKIP_BACKUP=1
                shift
                ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}"
                exit 1
                ;;
        esac
    done
}

# Function to check if script is run as root
check_not_root() {
    if [ "$(id -u)" = "0" ]; then
        echo -e "${RED}This script should not be run as root${NC}"
        exit 1
    fi
}

# Enhanced function to check if a command exists
command_exists() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo -e "${RED}Command '$1' not found${NC}"
        return 1
    fi
    return 0
}

# Enhanced internet connectivity check
check_internet() {
    echo -e "${YELLOW}Checking internet connection...${NC}"
    local timeout=5
    if ! ping -c 1 -W "$timeout" 8.8.8.8 >/dev/null 2>&1; then
        if ! ping -c 1 -W "$timeout" 1.1.1.1 >/dev/null 2>&1; then
            echo -e "${RED}No internet connection. Please connect to the internet and try again.${NC}"
            exit 1
        fi
    fi
    echo -e "${GREEN}Internet connection verified.${NC}"
}

# Enhanced system requirements check
check_system() {
    echo -e "${YELLOW}Checking system requirements...${NC}"
    
    # Check if running on Arch Linux
    if [ ! -f /etc/arch-release ]; then
        echo -e "${RED}This script is designed for Arch Linux${NC}"
        exit 1
    fi
    
    # Check available disk space
    local available_space=$(df -m /home | awk 'NR==2 {print $4}')
    if [ "$available_space" -lt "$MIN_DISK_SPACE" ]; then
        echo -e "${RED}Insufficient disk space. At least ${MIN_DISK_SPACE}MB required.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}System requirements met.${NC}"
}

# Enhanced error handling
handle_error() {
    local exit_code=$?
    local error_msg="$1"
    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Error: $error_msg (Exit code: $exit_code)${NC}"
        echo -e "${YELLOW}Check the log file for more details: $LOGFILE${NC}"
        if [ "$DRY_RUN" -eq 0 ]; then
            echo -e "${YELLOW}Attempting to restore from backup...${NC}"
            restore_from_backup
        fi
        exit $exit_code
    fi
}

# Enhanced backup function
backup_existing_configs() {
    if [ "$SKIP_BACKUP" -eq 1 ]; then
        echo -e "${YELLOW}Skipping backup as per user request${NC}"
        return 0
    fi

    echo -e "${YELLOW}Backing up existing configurations...${NC}"
    
    mkdir -p "$BACKUP_DIR" || handle_error "Failed to create backup directory"
    
    local configs=(
        ".bashrc"
        ".config/i3"
        ".config/nano"
        ".config/rofi"
        ".config/alacritty"
        ".config/dunst"
        ".bash_profile"
    )
    
    for config in "${configs[@]}"; do
        if [ -e ~/"$config" ]; then
            if [ "$DRY_RUN" -eq 0 ]; then
                cp -r ~/"$config" "$BACKUP_DIR/" || handle_error "Failed to backup $config"
                echo -e "${GREEN}Backed up $config${NC}"
            else
                echo -e "${BLUE}Would backup: $config${NC}"
            fi
        fi
    done
    
    echo -e "${GREEN}Configs backed up to $BACKUP_DIR${NC}"
}

# Restore from backup function
restore_from_backup() {
    if [ ! -d "$BACKUP_DIR" ]; then
        echo -e "${RED}No backup directory found at $BACKUP_DIR${NC}"
        return 1
    fi

    echo -e "${YELLOW}Restoring from backup...${NC}"
    for config in "$BACKUP_DIR"/*; do
        if [ -e "$config" ]; then
            local target=~/"$(basename "$config")"
            cp -r "$config" "$target" || echo -e "${RED}Failed to restore $(basename "$config")${NC}"
        fi
    done
    echo -e "${GREEN}Restore complete${NC}"
}

# Enhanced package installation function
install_packages() {
    local package_group=("$@")
    local failed_packages=()
    
    for package in "${package_group[@]}"; do
        echo -e "${YELLOW}Installing $package...${NC}"
        if [ "$DRY_RUN" -eq 0 ]; then
            if ! sudo pacman -S --noconfirm --needed "$package"; then
                failed_packages+=("$package")
                echo -e "${RED}Failed to install $package${NC}"
            fi
        else
            echo -e "${BLUE}Would install: $package${NC}"
        fi
    done
    
    if [ ${#failed_packages[@]} -ne 0 ]; then
        echo -e "${RED}Failed to install the following packages:${NC}"
        printf '%s\n' "${failed_packages[@]}"
        return 1
    fi
}

# Enhanced stow function
safe_stow() {
    local stow_dir="$1"
    local orig_dir=$(pwd)
    
    if [ ! -d "$stow_dir" ]; then
        echo -e "${RED}Stow directory $stow_dir not found${NC}"
        return 1
    fi
    
    # Verify dotfiles structure
    local required_dirs=(".config/i3" ".config/rofi" "Pictures/Wallpapers")
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$stow_dir/$dir" ]; then
            echo -e "${RED}Missing required directory: $dir${NC}"
            return 1
        fi
    done
    
    cd "$stow_dir" || handle_error "Failed to change to stow directory"
    echo -e "${YELLOW}Stowing configurations from $(pwd)...${NC}"
    
    if [ "$DRY_RUN" -eq 0 ]; then
        # First simulate stow to check for conflicts
        if ! stow -n .; then
            cd "$orig_dir"
            handle_error "Stow simulation failed - conflicts detected"
        fi
        
        # If simulation successful, perform actual stow
        if ! stow . --target="$HOME" --restow; then
            cd "$orig_dir"
            handle_error "Failed to stow configurations"
        fi
    else
        echo -e "${BLUE}Would stow configurations from $stow_dir${NC}"
    fi
    
    cd "$orig_dir"
    echo -e "${GREEN}Successfully processed stow operation${NC}"
}

# Git configuration function
configure_git() {
    if [ "$SKIP_GIT" -eq 1 ]; then
        echo -e "${YELLOW}Skipping Git configuration as per user request${NC}"
        return 0
    fi

    echo -e "${YELLOW}Do you want to configure Git with your username and email? (y/n)${NC}"
    read -r configure_git
    
    if [[ "$configure_git" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Please enter your GitHub username:${NC}"
        read -r github_username
        
        # Validate username
        if [ -z "$github_username" ]; then
            echo -e "${RED}Username cannot be empty${NC}"
            return 1
        fi
        
        echo -e "${YELLOW}Please enter your GitHub email:${NC}"
        read -r github_email
        
        # Validate email
        if [[ ! "$github_email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
            echo -e "${RED}Invalid email format${NC}"
            return 1
        fi
        
        if [ "$DRY_RUN" -eq 0 ]; then
            git config --global user.name "$github_username"
            git config --global user.email "$github_email"
            git config --global init.defaultBranch main
            git config --global core.editor nano
            echo -e "${GREEN}Git configured for user: $github_username${NC}"
        else
            echo -e "${BLUE}Would configure Git for user: $github_username${NC}"
        fi
    else
        echo -e "${YELLOW}Skipping Git configuration as per user choice.${NC}"
    fi
}

# Verify installation function
verify_installation() {
    echo -e "${YELLOW}Verifying installation...${NC}"
    local verify_failed=0
    
    # Verify important packages
    local critical_packages=("i3" "rofi" "alacritty" "dunst")
    for package in "${critical_packages[@]}"; do
        if ! pacman -Qi "$package" >/dev/null 2>&1; then
            echo -e "${RED}Critical package $package is not installed${NC}"
            verify_failed=1
        fi
    done
    
    # Verify config files
    local config_files=(
        "~/.config/i3/config"
        "~/.config/rofi/config.rasi"
        "~/.config/nano/nanorc"
    )
    for config in "${config_files[@]}"; do
        if [ ! -f "${config/#\~/$HOME}" ]; then
            echo -e "${RED}Configuration file $config is missing${NC}"
            verify_failed=1
        fi
    done
    
    # Verify permissions
    if [ ! -x ~/Pictures/Wallpapers/set_random_wallpaper.sh ]; then
        echo -e "${RED}Wallpaper script is not executable${NC}"
        verify_failed=1
    fi
    
    if [ $verify_failed -eq 1 ]; then
        echo -e "${RED}Installation verification failed${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Installation verification successful${NC}"
    return 0
}

# Main installation function
main() {
    # Parse command line arguments
    parse_arguments "$@"
    
    # Create log file directory
    mkdir -p "$(dirname "$LOGFILE")"
    
    # Start logging
    exec > >(tee -a "$LOGFILE") 2>&1
    
    # Print banner
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║         System Setup Installation         ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}"
    
    if [ "$DRY_RUN" -eq 1 ]; then
        echo -e "${YELLOW}Running in dry-run mode - no changes will be made${NC}"
    fi
    
    echo -e "${BLUE}Logging the installation process to $LOGFILE${NC}"
    
    # Initial checks
    check_not_root
    check_internet
    check_system
    
    # Backup existing configurations
    backup_existing_configs
    
    if [ "$SKIP_PACKAGES" -eq 0 ]; then
        # System update
        echo -e "${YELLOW}Updating system...${NC}"
        if [ "$DRY_RUN" -eq 0 ]; then
            sudo pacman -Syu --noconfirm || handle_error "System update failed"
        else
            echo -e "${BLUE}Would update system${NC}"
        fi
        
        # Install package groups
        echo -e "${YELLOW}Installing core packages...${NC}"
        install_packages "${CORE_PACKAGES[@]}"
        
        echo -e "${YELLOW}Installing window manager packages...${NC}"
        install_packages "${WM_PACKAGES[@]}"
        
        echo -e "${YELLOW}Installing utility packages...${NC}"
        install_packages "${UTILITY_PACKAGES[@]}"
        
        echo -e "${YELLOW}Installing file manager packages...${NC}"
        install_packages "${FILE_MANAGER_PACKAGES[@]}"
    else
        echo -e "${YELLOW}Skipping package installation as per user request${NC}"
    fi
    
    # Configure Git
    configure_git
    
    # Set screen brightness
    echo -e "${YELLOW}Setting screen brightness to 3%...${NC}"
    if [ "$DRY_RUN" -eq 0 ]; then
        sudo brightnessctl set 3% || handle_error "Failed to set brightness"
    else
        echo -e "${BLUE}Would set brightness to 3%${NC}"
    fi
    
    # Install yay if not present
    if ! command_exists yay; then
        echo -e "${YELLOW}Installing yay AUR helper...${NC}"
        if [ "$DRY_RUN" -eq 0 ]; then
            local tmp_dir=$(mktemp -d)
            git clone https://aur.archlinux.org/yay-bin.git "$tmp_dir" || handle_error "Failed to clone yay"
            (cd "$tmp_dir" && makepkg -si --noconfirm) || handle_error "Failed to install yay"
            rm -rf "$tmp_dir"
        else
            echo -e "${BLUE}Would install yay${NC}"
        fi
    fi
    
    # Enable services
    echo -e "${YELLOW}Enabling system services...${NC}"
    if [ "$DRY_RUN" -eq 0 ]; then
        sudo systemctl enable --now bluetooth || handle_error "Failed to enable bluetooth"
    else
        echo -e "${BLUE}Would enable bluetooth service${NC}"
    fi
    
    # Create directory structure
    echo -e "${YELLOW}Creating directory structure...${NC}"
    local dirs=(
        "$HOME/Documents"
        "$HOME/Downloads"
        "$HOME/Pictures"
        "$HOME/Music"
        "$HOME/Videos"
        "$HOME/Projects"
        "$HOME/.config/i3"
        "$HOME/.config/nano"
        "$HOME/.config/rofi"
        "$HOME/.config/dunst"
        "$HOME/.config/alacritty"
    )
    
    for dir in "${dirs[@]}"; do
        if [ "$DRY_RUN" -eq 0 ]; then
            mkdir -p "$dir" || handle_error "Failed to create directory: $dir"
        else
            echo -e "${BLUE}Would create directory: $dir${NC}"
        fi
    done
    
    # Copy X11 configuration
    echo -e "${YELLOW}Copying X11 configuration...${NC}"
    if [ -f "40-libinput.conf" ]; then
        if [ "$DRY_RUN" -eq 0 ]; then
            sudo cp 40-libinput.conf /etc/X11/xorg.conf.d/ || handle_error "Failed to copy 40-libinput.conf"
        else
            echo -e "${BLUE}Would copy 40-libinput.conf to /etc/X11/xorg.conf.d/${NC}"
        fi
    else
        echo -e "${RED}Warning: 40-libinput.conf not found${NC}"
    fi
    
    # Stow dotfiles
    echo -e "${YELLOW}Stowing dotfiles...${NC}"
    safe_stow "dotfiles"
    
    # Set permissions for wallpaper script
    local wallpaper_script="$HOME/Pictures/Wallpapers/set_random_wallpaper.sh"
    if [ -f "$wallpaper_script" ]; then
        if [ "$DRY_RUN" -eq 0 ]; then
            chmod +x "$wallpaper_script" || handle_error "Failed to set script permissions"
        else
            echo -e "${BLUE}Would set executable permissions for wallpaper script${NC}"
        fi
    else
        echo -e "${RED}Warning: Wallpaper script not found at $wallpaper_script${NC}"
    fi
    
    # Clean up
    echo -e "${YELLOW}Cleaning up...${NC}"
    if [ "$DRY_RUN" -eq 0 ]; then
        # Clean package cache
        sudo pacman -Sc --noconfirm || handle_error "Failed to clean package cache"
        
        # Remove old bash profile if it exists
        if [ -f "$HOME/.bash_profile" ]; then
            rm "$HOME/.bash_profile" || handle_error "Failed to remove .bash_profile"
        fi
    else
        echo -e "${BLUE}Would clean package cache and remove old .bash_profile${NC}"
    fi
    
    # Verify installation
    if [ "$DRY_RUN" -eq 0 ]; then
        verify_installation || handle_error "Installation verification failed"
    fi
    
    # Installation complete
    echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         Installation Complete!            ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}Installation log: $LOGFILE${NC}"
    echo -e "${YELLOW}Backup directory: $BACKUP_DIR${NC}"
    
    if [ "$DRY_RUN" -eq 1 ]; then
        echo -e "${YELLOW}This was a dry run - no changes were made${NC}"
    else
        echo -e "${CYAN}Please review the log file for any warnings or errors.${NC}"
        echo -e "${CYAN}A backup of your previous configuration is available at: $BACKUP_DIR${NC}"
        echo -e "${CYAN}Please reboot your system to apply all changes.${NC}"
    fi
}

# Run main function with all arguments
main "$@"