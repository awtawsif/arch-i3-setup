# Arch Linux i3 Setup Script

A comprehensive setup script for Arch Linux with i3 window manager, including dotfiles management and system configuration. This script automates the process of setting up a new Arch Linux installation with i3 window manager and various quality-of-life improvements.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Directory Structure](#directory-structure)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Packages](#packages)
- [Configuration](#configuration)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- A fresh Arch Linux installation
- Internet connection
- Base system packages (`base` `base-devel`)
- A non-root user with sudo privileges
- X.org server installed (`xorg` `xorg-xinit`)

## Directory Structure

```
Projects/i3-wm/
├── setup.sh                 # Main installation script
├── 40-libinput.conf        # X11 input configuration
├── README.md               # This file
└── dotfiles/
    ├── .bashrc            # Bash configuration
    ├── .config/
    │   ├── i3/
    │   │   ├── config     # Main i3 configuration
    │   │   └── config.d/
    │   │       ├── keybindings.conf
    │   │       ├── startup.conf
    │   │       └── workspaces.conf
    │   ├── i3rs-config.toml   # i3status-rust configuration
    │   ├── nano/
    │   │   └── nanorc        # Nano editor configuration
    │   └── rofi/
    │       └── config.rasi   # Rofi launcher configuration
    └── Pictures/
        └── Wallpapers/
            ├── set_random_wallpaper.sh
            └── *.jpg         # Wallpaper files
```

## Features

- ✨ Automated system setup
- 🔒 Secure configuration backup and restore
- 📦 Organized package management
- 🎨 Pre-configured desktop environment
- ⚡ Performance optimizations
- 🛠 Development tools setup
- 🔧 Hardware support configuration
- 📝 Detailed logging
- 🔍 Installation verification

### Key Components

1. **Window Manager**: i3-gaps with i3status-rust
2. **Application Launcher**: Rofi
3. **Terminal**: Alacritty
4. **File Manager**: Thunar
5. **Notification System**: Dunst
6. **Text Editor**: Nano with syntax highlighting
7. **Development Tools**: Git, base-devel, and more

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/arch-i3-setup.git
cd arch-i3-setup
```

2. Make the script executable:
```bash
chmod +x setup.sh
```

3. Run the script:
```bash
./setup.sh
```

## Usage

### Command Line Options

```bash
./setup.sh [options]
```

Available options:
- `--dry-run`: Test the installation without making changes
- `--skip-packages`: Skip package installation
- `--skip-git`: Skip Git configuration
- `--skip-backup`: Skip configuration backup

### Example Usage

```bash
# Full installation
./setup.sh

# Test run without making changes
./setup.sh --dry-run

# Install without Git configuration
./setup.sh --skip-git

# Install without creating backups
./setup.sh --skip-backup
```

## Packages

### Core Packages
- `stow`: Symlink farm manager
- `alacritty`: Terminal emulator
- `git`: Version control
- `base-devel`: Development tools
- `brightnessctl`: Brightness control
- `python-i3ipc`: i3 IPC Python library

### Window Manager Packages
- `i3status-rust`: Status bar
- `rofi`: Application launcher
- `dunst`: Notification daemon
- `hsetroot`: Wallpaper setter

### Utility Packages
- `mousepad`: Text editor
- `bash-completion`: Bash completion
- `zip/unzip`: Compression utilities
- `neofetch`: System information
- `curl/wget`: File download utilities

### File Manager Packages
- `thunar`: File manager
- `thunar-volman`: Volume manager
- `thunar-archive-plugin`: Archive plugin
- `gvfs`: Virtual filesystem

## Configuration

### Dotfiles
The script uses GNU Stow to manage dotfiles. All configuration files are stored in the `dotfiles` directory and are automatically symlinked to their correct locations.

### Customization Points

1. **i3 Configuration** (`~/.config/i3/config.d/`):
   - `keybindings.conf`: Keyboard shortcuts
   - `startup.conf`: Autostart applications
   - `workspaces.conf`: Workspace layout

2. **Terminal** (`~/.config/alacritty/`):
   - Font settings
   - Color schemes
   - Terminal behavior

3. **Application Launcher** (`~/.config/rofi/`):
   - Theme customization
   - Keyboard shortcuts
   - Search behavior

## Troubleshooting

### Logs
- Installation logs are stored in `~/setup_YYYYMMDD_HHMMSS.log`
- Each installation creates a unique log file
- Check logs for error messages and warnings

### Common Issues

1. **Package Installation Fails**
   ```bash
   # Update package database
   sudo pacman -Syy
   # Try installation again
   ./setup.sh
   ```

2. **Stow Conflicts**
   ```bash
   # Backup existing configs
   mv ~/.config/i3 ~/.config/i3.bak
   # Run script again
   ./setup.sh
   ```

3. **Permission Issues**
   ```bash
   # Check user permissions
   groups
   # Ensure user is in required groups
   sudo usermod -aG wheel,video,audio $USER
   ```

### Backup and Restore

- Backups are stored in `~/config_backups/YYYYMMDD_HHMMSS/`
- Each backup includes all existing configurations
- Automatic restore on installation failure

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

### Development Guidelines

- Follow shell script best practices
- Test changes with `--dry-run`
- Update documentation
- Add comments for complex operations

## License

This project is licensed under the MIT License

## Acknowledgments

- i3 Window Manager team
- Arch Linux community
- GNU Stow developers
- All package maintainers

---

**Note**: This script is provided as-is. Always review scripts before running them and ensure they meet your needs. Make backups before making system-wide changes.