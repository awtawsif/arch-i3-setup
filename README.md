# Arch Linux i3 Window Manager Setup Script

## Overview

A comprehensive setup script for Arch Linux that installs and configures a complete i3 window manager environment with modern tools, audio system, security features, and theming for a productive standalone desktop experience.

## Features

- Complete i3 window manager configuration with Windows key mod
- Modern audio system (PipeWire) with media players
- Security tools (firewall, policy kit)
- Terminal setup (Alacritty with Tokyo Night theme)
- File management (Thunar with plugins)
- System monitoring and maintenance tools
- Modern CLI tools (exa, bat, fastfetch)
- Bluetooth support and device management
- Display manager (ly) with auto-start
- Desktop integration and user directories
- Comprehensive theming (Tokyo Night GTK theme, custom fonts)

## Package Groups

The script installs these main package groups:

### Core & System
- **Window Manager**: i3-wm, i3blocks, i3status-rust
- **Terminal**: alacritty with Tokyo Night theme
- **System Tools**: htop, exa, bat, fastfetch, brightnessctl
- **Desktop Integration**: xdg-user-dirs, polkit, gparted
- **Development**: github-cli, visual-studio-code-bin, npm
- **Utilities**: copyq, wget, xclip, jq, bash-completion
- **Display**: ly (display manager), xss-lock
- **Bluetooth**: bluez, bluez-utils, blueman
- **Network**: network-manager-applet, xdg-desktop-portal-gtk

### Audio & Media
- **Audio System**: pipewire, pipewire-pulse, pipewire-alsa, pavucontrol
- **Codecs**: ffmpeg
- **Media Players**: vlc, mpv

### Security
- **Firewall**: firewalld

### File Management
- **File Manager**: thunar with plugins (volman, archive-plugin)
- **Archive Support**: unrar, zip, unzip, xarchiver, p7zip
- **Device Support**: gvfs, gvfs-mtp

### UI & Theming
- **Application Launcher**: rofi with emoji support
- **Notifications**: dunst
- **Screenshots**: flameshot
- **Wallpaper**: feh with random wallpaper script
- **Lock Screen**: i3lock-color
- **Fonts**: otf-font-awesome, ttf-jetbrains-mono-nerd, noto-fonts-emoji
- **Theme**: tokyonight-gtk-theme-git
- **Icons**: tumbler (thumbnail generation)

### Browser
- **Web Browser**: firefox

## Prerequisites

- Fresh Arch Linux installation with Xorg
- Internet connection
- Non-root user with sudo privileges

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/awtawsif/arch-i3-setup.git
   cd arch-i3-setup
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```

3. During installation, you'll be prompted to:
   - Configure Git (optional)
   - Enter sudo password when required

## What the Script Does

1. **System Checks**: Validates user permissions, internet connection, and required files
2. **Git Configuration**: Optional setup of Git user details
3. **AUR Setup**: Installs yay AUR helper and configures Chaotic-AUR repository
4. **Package Installation**: Installs all required packages from official repos and AUR
5. **Service Configuration**: Enables bluetooth and ly display manager services
6. **Directory Structure**: Creates standard user directories (Documents, Downloads, etc.)
7. **Configuration Files**: Copies all dotfiles and config files to home directory
8. **Input Devices**: Configures touchpad and input device settings
9. **System Integration**: Sets up desktop integration components

## Post-Installation

After installation completes:
1. **Reboot your system** to apply all changes
2. **Log in** through ly display manager
3. **i3 will start automatically** with your configured environment

### Key Bindings
- **$mod+Return**: Open terminal (Alacritty)
- **$mod+d**: Application launcher (Rofi)
- **$mod+Shift+f**: File manager (Thunar)
- **$mod+Shift+b**: Browser (Firefox)
- **$mod+Shift+c**: Code editor (VS Code)
- **$mod+Shift+t**: Text editor (Mousepad)
- **$mod+Print**: Screenshot (Flameshot)
- **$mod+Shift+r**: Reload i3 configuration

### Configuration Details
- **Mod Key**: Windows/Super key (Mod4)
- **Theme**: Tokyo Night GTK theme with matching colors
- **Terminal**: Alacritty with Tokyo Night theme and JetBrains Mono Nerd Font
- **Audio**: PipeWire with pavucontrol for volume management
- **Display**: ly display manager with auto-start
- **Wallpaper**: Random wallpaper script that changes on i3 reload

## Configuration Files Included

### i3 Window Manager
- **Main Config**: `.config/i3/config` - Complete i3 configuration
- **Keybindings**: `.config/i3/config.d/keybindings.conf` - All window management keybindings
- **Workspaces**: `.config/i3/config.d/workspaces.conf` - Workspace configuration
- **Startup**: `.config/i3/config.d/startup.conf` - Autostart applications
- **Wallpaper**: `.config/i3/set_random_wallpaper.sh` - Random wallpaper script

### Terminal & Shell
- **Alacritty**: `.config/alacritty/alacritty.toml` - Terminal configuration
- **Theme**: `.config/alacritty/themes/tokyo_night.toml` - Tokyo Night theme
- **Bash**: `.bashrc` - Shell configuration and aliases
- **Profile**: `.profile` - Environment variables and PATH setup

### UI Components
- **Rofi**: `.config/rofi/config.rasi` - Application launcher styling
- **Theme**: `.config/rofi/themes/tokyonight.rasi` - Tokyo Night Rofi theme
- **i3status**: `.config/i3rs-config.toml` - Status bar configuration

### System Tools
- **Nano**: `.config/nano/nanorc` - Enhanced nano editor configuration
- **Htop**: `.config/htop/htoprc` - Process monitor configuration
- **Thunar**: `.config/Thunar/uca.xml` - Custom actions for file manager

### System Integration
- **Input**: `40-libinput.conf` - Touchpad and input device configuration

## Troubleshooting

- **Missing Files**: Ensure all required files are present before running the script
- **Internet Connection**: Verify stable internet connection for package downloads
- **Permissions**: Run script as non-root user with sudo privileges
- **Directory**: Make sure script is run from the correct directory
- **Audio**: If audio doesn't work, check PipeWire service status
- **Display**: If ly doesn't start, check Xorg installation and graphics drivers

## Contributing

Feel free to submit issues and pull requests for:
- Bug fixes and improvements
- New package suggestions
- Documentation updates
- Configuration enhancements
- Theme customizations

## License

This project is open source and available under the MIT License.
