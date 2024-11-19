# System Setup Installation Script

A comprehensive bash script for automating the setup and configuration of an Arch Linux system with i3 window manager. This script handles package installation, system configuration, and dotfiles management with extensive error handling and logging capabilities.

## 🚀 Features

- Full system update and package installation with organized package groups
- Automated dotfiles management using GNU Stow
- Git configuration setup
- AUR package support via `yay`
- Bluetooth service configuration
- Screen brightness management
- Comprehensive logging system
- Progress animations for long-running tasks
- Error handling and validation
- Color-coded output for better readability
- Force mode option to skip file/directory checks

## 📋 Prerequisites

- Arch Linux base installation
- Internet connection
- Non-root user with sudo privileges

## 📦 Package Groups

### Core Packages
- `base-devel` - Development tools
- `stow` - Symlink farm manager
- `alacritty` - Terminal emulator
- `brightnessctl` - Brightness control
- `nano-syntax-highlighting` - Syntax highlighting for nano
- `python-i3ipc` - Python i3 IPC library
- `mousepad` - Text editor
- `bash-completion` - Bash completion utilities

### Archive Packages
- `zip` - Compression utility
- `unzip` - Decompression utility
- `xarchiver` - Archive manager

### System Packages
- `neofetch` - System information tool
- `xss-lock` - X screen saver
- `bluez` & `bluez-utils` - Bluetooth support
- `blueman` - Bluetooth manager
- `lxappearance` - GTK theme switcher
- `man-db` - Manual pages

### File Manager Packages
- `thunar` - File manager
- `thunar-volman` - Volume manager
- `thunar-archive-plugin` - Archive plugin
- `gvfs` & `gvfs-mtp` - Virtual filesystem

### UI Packages
- `hsetroot` - Wallpaper utility
- `flameshot` - Screenshot tool
- `dunst` - Notification daemon
- `rofi` - Application launcher
- `i3status-rust` - Status bar

### Theme Packages
- `ttf-jetbrains-mono-nerd` - Font package
- `gnome-themes-standard` - GTK themes
- `papirus-icon-theme` - Icon theme

## 🚀 Installation

1. Clone the repository:
```bash
git clone https://github.com/abrar-wadud/arch-i3-setup.git
cd arch-i3-setup.git
```

2. Make the script executable:
```bash
chmod +x setup.sh
```

3. Run the script:
```bash
# Normal mode with all checks
./setup.sh

# Force mode to skip file/directory checks
./setup.sh --force
```

## ⚙️ Command Line Options

- `--force`: Skip the initial file and directory checks. Useful when:
  - Running the script from a different directory
  - Testing specific components
  - Reinstalling on an existing system

## 📝 Logging

- All installation steps are logged to a timestamped file: `~/setup_YYYYMMDD_HHMMSS.log`
- Errors and warnings are clearly marked in the log file
- Console output is color-coded for better readability
- Each package group installation is separately logged

## 🔧 Directory Structure

The script creates the following directory structure in your home folder:
```
~/
├── Documents/
├── Downloads/
├── Pictures/
│   └── Wallpapers/
├── Music/
├── Videos/
└── Projects/
```

## ⚠️ Important Notes

1. Do not run this script as root
2. Ensure you have a stable internet connection
3. The script will make changes to your system configuration
4. A system reboot is recommended after installation
5. No backup functionality is included as this script is designed for fresh installations
6. Package groups can be easily modified by editing the arrays at the top of the script

## 🐛 Troubleshooting

- Check the log file for detailed error messages
- Look for specific package group installation failures in the log
- Use `--force` option if you're having issues with file/directory checks
- Verify internet connectivity
- Make sure you have sudo privileges
- Check the package group arrays if you need to modify installed packages

## 🤝 Contributing

Feel free to fork this repository and submit pull requests for any improvements. Some areas you might consider:
- Adding new package groups
- Improving error handling
- Adding new features or configurations
- Optimizing installation process
