# Arch Linux i3 Window Manager Setup Script

## Who is This For?

This script is perfect for:
- New Arch Linux users
- Minimal Arch installation users
- Developers and power users
- Anyone wanting a streamlined i3 window manager setup

## 🚀 What This Script Does

Transforms a minimal Arch Linux installation into a fully configured development and productivity environment with i3 window manager, automating:
- System package installation
- Configuration file deployment
- Development environment setup
- Desktop environment customization

## 🔍 Detailed Prerequisites

### System Requirements
- Fresh Arch Linux installation (minimal or base install)
- Working internet connection
- Non-root user with sudo privileges

## 📦 What Gets Installed

### Core Utilities
- **System Monitoring**: htop
- **File Management**: exa, thunar
- **Text Editing**: nano
- **Terminal**: alacritty
- **Window Management**: i3-wm, i3blocks
- **Display Server**: Xorg

### Development Tools
- Base development tools
- Bash completion
- Git configuration support

### Aesthetic & Usability
- Papirus icon theme
- JetBrains Mono Nerd Font
- Rofi application launcher
- Dunst notification daemon

## 🛠 Pre-Installation Checklist

1. Complete minimal Arch Linux installation
2. Ensure sudo access for current user
3. Connect to internet
4. Clone this repository
5. Navigate to script directory

## 🔧 Installation Modes

### Standard Installation
```bash
./setup.sh
```
- Performs all checks
- Prompts for Git configuration
- Installs all packages
- Configures system

### Force Mode
```bash
./setup.sh --force
```
- Skips prerequisite checks
- Useful for experienced users
- Use with caution

## 🤔 What Happens During Installation?

1. Internet connectivity check
2. Script prerequisite verification
3. Optional Git configuration
4. AUR helper (yay) installation
5. System package updates
6. Package group installations
7. System service enablement
8. User directory creation
9. Configuration file deployment
10. System cleanup

## 🛡️ Safety & Customization

### Customization Options
- Edit package arrays in script
- Add/remove packages as needed
- Modify configuration file copying

### Safety Features
- Comprehensive error handling
- Detailed logging
- Non-root execution requirement
- Internet connectivity verification

## 🔍 Troubleshooting

### Common Issues
- Ensure sudo privileges
- Check internet connection
- Verify Arch Linux base system
- Review installation log

### Log File
- Located at `~/setup_[timestamp].log`
- Contains detailed installation information

## 📋 Post-Installation Steps

1. Reboot system
2. Review configuration files
3. Customize to personal preference

## ⚠️ Important Warnings

- Review script before execution
- Understand each step
- Backup important data
- Not recommended for production servers without review

## 🤝 Contributing

Contributions welcome!
1. Fork repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create pull request

## 🆘 Support

- Open GitHub issues for bugs
- Provide detailed error logs
- Be specific about your environment

## 📚 Learning Resources

- [Arch Linux Wiki](https://wiki.archlinux.org/)
- [i3 Window Manager Documentation](https://i3wm.org/docs/)
- Linux community forums

## 🎉 Enjoy Your New Environment!

Transform your minimal Arch installation into a powerful, personalized workstation with just one script!
