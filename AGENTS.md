# Arch Linux i3 Setup - Agent Guidelines

## Build/Test Commands
- `./setup.sh` - Main installation script (run as non-root user)
- `./install_packages.sh` - Package installation component
- `./setup_aur.sh` - AUR helper setup component
- No formal test suite - validate by checking i3 config syntax: `i3 -C`

## Code Style Guidelines

### Bash Scripts
- Use `#!/bin/bash` shebang
- Color variables: GREEN, RED, YELLOW, CYAN, NC with \033 escape codes
- Function names: snake_case (e.g., `check_system`, `setup_git`)
- Error handling: Return 1 on failure, use `|| return 1` for chaining
- Echo statements: Use color variables with ${NC} reset
- Sudo operations: Cache credentials with `sudo -v` before operations

### Configuration Files
- i3 config: Use `$mod` for Mod1 (Alt), organize with includes
- TOML files: Follow existing structure, use double quotes for strings
- File paths: Use absolute paths in scripts, relative in configs

### General Conventions
- Imports: Source scripts with `./script_name.sh`
- Formatting: 4-space indentation, consistent bracket style
- Naming: Descriptive function/variable names, lowercase with underscores
- Comments: Minimal, only for complex logic
- Error messages: Use color-coded echo with descriptive text