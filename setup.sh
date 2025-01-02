#!/bin/bash

# Color definitions
NC="\033[0m"
for color in GREEN RED YELLOW BLUE CYAN; do
    declare "$color=\033[0;3$(([GREEN]=2,[RED]=1,[YELLOW]=3,[BLUE]=4,[CYAN]=6)[$color])m"
done

# Consolidated package groups
PACKAGES=(
    # Core & System
    htop exa bat alacritty brightnessctl nano nano-syntax-highlighting
    mousepad bash-completion i3-wm i3blocks fastfetch xss-lock
    bluez bluez-utils blueman lxappearance man-db ly network-manager-applet
    # File Management
    thunar thunar-volman thunar-archive-plugin gvfs gvfs-mtp
    unrar zip unzip xarchiver
    # UI & Theming
    feh flameshot dunst rofi i3status-rust tumbler
    ttf-font-awesome ttf-jetbrains-mono-nerd noto-fonts-emoji
    gnome-themes-standard papirus-icon-theme
)

LOGFILE=~/setup_$(date +%Y%m%d_%H%M%S).log
exec > >(tee -a "$LOGFILE") 2>&1

# Add sudo credential caching
cache_sudo_credentials() {
    echo -e "${YELLOW}Caching sudo credentials...${NC}"
    sudo -v
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
}

# Simplified functions
check_system() {
    [[ "$(id -u)" == "0" ]] && { echo -e "${RED}Don't run as root${NC}"; exit 1; }
    cache_sudo_credentials || { echo -e "${RED}Failed to cache sudo credentials${NC}"; exit 1; }
    ping -c 1 8.8.8.8 >/dev/null 2>&1 || { echo -e "${RED}No internet connection${NC}"; exit 1; }
    [[ ! -f "./setup.sh" ]] && { echo -e "${RED}Run from correct directory${NC}"; exit 1; }
    for item in "40-libinput.conf" ".bashrc" "Wallpapers" ".config"; do
        [[ ! -e "$item" ]] && { echo -e "${RED}Missing: $item${NC}"; exit 1; }
    done
}

install_packages() {
    sudo pacman -Syu --noconfirm || return 1
    sudo pacman -S --noconfirm --needed "${PACKAGES[@]}" || return 1
    
    command -v yay || {
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
        (cd /tmp/yay-bin && makepkg -si --noconfirm)
        rm -rf /tmp/yay-bin
    }
}

setup_git() {
    echo -e "${YELLOW}Configure Git? (y/n)${NC}"
    read -r response
    [[ "$response" == [yY] ]] && {
        read -rp "GitHub username: " username
        read -rp "GitHub email: " email
        git config --global user.name "$username"
        git config --global user.email "$email"
    }
}

install_browser() {
    echo -e "${YELLOW}Select browser:\n1) Firefox\n2) Chromium\n3) Brave\n4) Skip${NC}"
    read -rp "Choice [1-4]: " choice
    case $choice in
        1) sudo pacman -S --noconfirm firefox ;;
        2) sudo pacman -S --noconfirm chromium ;;
        3) yay -S --noconfirm brave-bin ;;
    esac
}

main() {
    echo -e "${CYAN}╔════════ System Setup Installation ════════╗${NC}"
    
    check_system
    setup_git
    install_packages
    install_browser

    # Quick setup commands
    sudo brightnessctl set 3% || true
    sudo systemctl enable bluetooth ly.service
    
    # Create dirs and copy files
    mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Music ~/Videos ~/Projects
    sudo mkdir -p /etc/X11/xorg.conf.d/
    sudo cp 40-libinput.conf /etc/X11/xorg.conf.d/
    cp .bashrc ~/
    cp -r .config ~/
    cp -r Wallpapers ~/Pictures/
    chmod +x ~/Pictures/Wallpapers/set_random_wallpaper.sh
    rm -f ~/.bash_profile
    
    echo -e "${GREEN}Installation Complete! Please reboot.${NC}"
}

main "$@"
