# System Setup Script

This bash script automates the setup and configuration of an Arch Linux system, installing essential packages and configuring system settings, including customizing user profiles, setting up necessary directories, and applying configurations.

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Features](#features)
- [Usage](#usage)
- [Configuration Details](#configuration-details)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Requirements

- Arch Linux with i3 window manager.
- An internet connection to install packages and clone repositories.
- `sudo` access for administrative operations.

## Installation

1. Clone the repository to your local machine:
    ```bash
    git clone https://github.com/abrar-wadud/i3-wm.git
    cd i3-wm
    ```

2. Make the setup script executable:
    ```bash
    chmod +x setup.sh
    ```

3. Run the script:
    ```bash
    ./setup.sh
    ```

## Features

- **System Update**: Updates all installed packages to the latest versions using `pacman`.
- **Essential Package Installation**: Installs necessary packages like `git`, `brightnessctl`, `bluez`, `thunar`, `rofi`, and others for a fully functional desktop environment.
- **Yay AUR Helper Installation**: Installs the `yay` AUR helper for managing AUR packages if it is not already installed.
- **Git Configuration**: Optionally sets up your Git username and email for version control.
- **Directory Setup**: Creates essential directories (`Documents`, `Downloads`, `Projects`, etc.) in your home directory.
- **Configuration File Deployment**: Copies various configuration files (e.g., `.bashrc`, i3 configuration files) and sets appropriate permissions.
- **System Services Management**: Enables and starts services like Bluetooth.
- **System Cleanup**: Cleans up the package cache to free space after installation.

## Usage

1. **System Update and Package Installation**: The script first updates the system and installs essential packages, including `brightnessctl` for managing screen brightness.
2. **Git Configuration**: You will be asked if you want to set up your Git username and email during the script execution. If you choose "Yes," you will be prompted to enter your Git details. If you prefer to skip this, the script will continue without setting up Git.
3. **Screen Brightness Adjustment**: Automatically sets screen brightness to 3% (can be modified in the script if needed).
4. **AUR Helper Installation**: If `yay` is not installed, it will be cloned, built, and installed from the AUR.
5. **Bluetooth Service Activation**: The script enables and starts the Bluetooth service.
6. **Directory Creation**: Sets up commonly used directories in your home folder.
7. **Configuration File Setup**: Copies the necessary configuration files and applies the correct permissions.
8. **Package Cache Cleanup**: Clears the package cache to optimize system space usage.

## Configuration Details

The script includes multiple configuration steps:

- **Git Configuration**:
    - If you choose to configure Git, you'll be prompted to enter:
        - Your Git username (e.g., `your-username`)
        - Your Git email (e.g., `your-email@example.com`)

- **Directories Created**:
    - `~/Documents`
    - `~/Downloads`
    - `~/Pictures`
    - `~/Music`
    - `~/Videos`
    - `~/Projects`

- **Packages Installed**:
    - Common packages such as:
        - `noto-fonts-emoji`
        - `bash-completion`
        - `neofetch`
        - `thunar`
        - `rofi`
        - `bluez`, `bluez-utils`, and more.

- **Bluetooth Service**:
    - Enables and starts the `bluetooth` service using `systemctl`.

## Troubleshooting

If you encounter any issues while running the script, consider the following:

- **Permissions**: Make sure the script has executable permissions:
    ```bash
    chmod +x setup.sh
    ```

- **Pacman Errors**: If you encounter issues with `pacman` (e.g., locked databases), you might need to unlock it:
    ```bash
    sudo rm /var/lib/pacman/db.lck
    ```

- **AUR Helper Installation Fails**:
    - Ensure that `git` and `base-devel` are installed properly before running the script.
    - Verify that the internet connection is active, as the script will clone the `yay` repository.

- **Customizing the Script**:
    - Feel free to modify the script to adjust package names, set different configurations, or add more customizations to suit your needs.

## License

This project is open-source and available under the [MIT License](LICENSE).

---

> **Note**: This script is only designed for Arch Linux with i3 window manager. It may not work as expected on other Linux distributions.
