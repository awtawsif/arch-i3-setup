# Arch Linux i3 Window Manager Setup Script

## Who is This For?

This script is perfect for:
- New Arch Linux users
- Minimal Arch installation users
- Developers and power users
- Anyone wanting a streamlined i3 window manager setup

## What This Script Does

Transforms a minimal Arch Linux installation into a fully configured development and productivity environment with i3 window manager, featuring:
- Automated system package installation
- Automatic backup and restore of configurations
- Smart package group management
- Development environment setup
- Desktop environment customization

## 🔍 Detailed Prerequisites

### System Requirements
- Fresh Arch Linux installation (minimal or base install)
- Working internet connection
- Non-root user with sudo privileges

## 📦 Package Groups

The script organizes packages into logical groups:
- **Core**: Essential system components
- **Archive**: File compression tools
- **System**: System utilities and services
- **File Manager**: File management tools
- **UI**: User interface components
- **Theme**: Fonts and visual customization

## 🛡️ Safety Features

### Automatic Backup
- Creates timestamped backups before installation
- Backs up existing configurations to `~/.config_backups/`
- Automatic rollback on failure

### Error Handling
- Comprehensive error detection
- Automatic configuration restoration on failure
- Detailed logging of all operations
- Interrupt handling with safe cleanup

### Safety Checks
- Non-root execution requirement
- Internet connectivity verification
- Package verification after installation
- Configuration validation

## 🛠 Pre-Installation Checklist

1. Complete Xorg Arch Linux installation
2. Ensure sudo access for current user
3. Connect to internet
4. Clone this repository
5. Navigate to script directory

## 🔧 Installation Modes

### Standard Installation
```bash
./setup.sh
```

### Force Mode
```bash
./setup.sh --force
```
Skips prerequisite checks (use with caution)

## 📋 Installation Process

1. Safety checks and backups
2. Git configuration (optional)
3. AUR helper (yay) installation
4. Package installations by group
5. Browser installation (user choice)
6. System service configuration
7. Directory structure setup
8. Configuration deployment
9. System cleanup

## 🔍 Troubleshooting

### Installation Log
- Located at `~/setup_[timestamp].log`
- Contains detailed operation information
- Useful for debugging issues

### Common Issues
- Ensure sudo privileges
- Check internet connection
- Verify file permissions
- Review backup directory if restore needed

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
