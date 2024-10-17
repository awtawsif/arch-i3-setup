# ~/.bashrc

# 1. Ensure the script is not run multiple times
# This checks if the environment variable 'BASHRC_LOADED' is already set.
# If it's set, the script exits (returns) to prevent re-execution if the file is sourced again.
# This avoids unnecessary reloading of configurations and aliases, improving efficiency.
if [ "$BASHRC_LOADED" ]; then
    return
fi
export BASHRC_LOADED=1

# 2. Prompt Customization: A colorful, informative prompt
# The PS1 variable defines the primary prompt shown in the terminal.
# The prompt includes:
#   - \u: The username of the current user.
#   - \h: The hostname of the machine.
#   - \w: The current working directory.
#   - Colors to visually separate components:
#     - Green (\e[0;32m) for the user and hostname.
#     - Blue (\e[0;34m) for the working directory.
#   - A newline (\n) to move the command input to the next line.
#   - \$: Shows '$' for normal users and '#' for root, indicating the privilege level.
PS1='\[\e[0;32m\]\u@\h:\[\e[0;34m\]\w\[\e[0;32m\]\n\$ \[\e[0m\]'

# 3. Color Definitions: Easy-to-use color variables for scripts
# These variables define color codes that can be used for formatted output.
# Useful in scripts and commands for highlighting or organizing terminal output.
export BLACK='\e[0;30m'
export RED='\e[0;31m'
export GREEN='\e[1;32m'
export YELLOW='\e[0;33m'
export BLUE='\e[0;34m'
export MAGENTA='\e[0;35m'
export CYAN='\e[0;36m'
export WHITE='\e[0;37m'
export RESET='\e[0m'  # Resets the color back to default

# Usage Example:
# An alias that prints "Success!" in green text as an example of using the color variables.
alias success='echo -e "${GREEN}Success!${RESET}"'

# 4. Aliases: Shortcuts for common commands
# Aliases are defined to shorten frequently used commands and add options automatically.
alias ll='ls -alF --color=auto'   # Detailed list view with file types and colors
alias la='ls -A'                  # List all files except '.' and '..'
alias l='ls -CF'                  # Compact list format with file types
alias grep='grep --color=auto'   # Enable color highlighting for grep matches
alias df='df -h'                 # Human-readable disk usage output
alias du='du -h'                 # Human-readable directory size output
alias cls='clear'                # Alias for clearing the terminal screen

# 5. Directory Navigation: Quick navigation through directories
# Aliases for quickly moving up the directory structure.
alias ..='cd ..'         # Go up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories

# 6. Custom Functions: Enhance shell functionality

# Extract archives based on file extension
# A function to automatically extract various archive types based on file extension.
# It simplifies the process of extracting files by using the appropriate tool.
extract () {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;       # Extract .tar.bz2 files
            *.tar.gz)  tar xzf $1 ;;       # Extract .tar.gz files
            *.bz2)     bunzip2 $1 ;;       # Extract .bz2 files
            *.rar)     unrar x $1 ;;       # Extract .rar files
            *.gz)      gunzip $1 ;;        # Extract .gz files
            *.tar)     tar xf $1 ;;        # Extract .tar files
            *.tbz2)    tar xjf $1 ;;       # Extract .tbz2 files
            *.tgz)     tar xzf $1 ;;       # Extract .tgz files
            *.zip)     unzip $1 ;;         # Extract .zip files
            *.Z)       uncompress $1 ;;    # Uncompress .Z files
            *.7z)      7z x $1 ;;          # Extract .7z files
            *)         echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"    # Error message if the input is not a file
    fi
}

# Search for a pattern in all files in a directory
# A custom function 'fgrep' to search recursively for a pattern in files within the current directory.
function fgrep() {
    grep -r "$1" *  # '-r' flag enables recursive search through all files
}

# 7. Environment Customizations: Set useful environment variables

# History Settings: Make history more useful
export HISTCONTROL=ignoreboth:erasedups  # Ignore duplicate commands and commands that start with a space
export HISTSIZE=10000                    # Store up to 10,000 commands in the history
export HISTFILESIZE=20000                # Save up to 20,000 commands in the history file
shopt -s histappend                      # Append new commands to the history file, rather than overwriting it

# Enable Autocorrect for minor mistakes
shopt -s cdspell  # Automatically corrects minor spelling errors when using 'cd'

# 9. Terminal Features: Enhancements for terminal experience

# Enable programmable completion features
# These settings enable enhanced tab completion for various commands and options.
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# 11. PS1 Customization based on User
# Change the prompt based on the current user. 
# - For root users, the prompt appears in red (\e[1;31m).
# - For normal users, it appears in green (\e[1;32m).
# This provides a visual cue about the privilege level.
if [ "$USER" == "root" ]; then
    PS1='\[\e[1;31m\]\u@\h:\w# \[\e[0m\]'
else
    PS1='\[\e[1;32m\]\u@\h:\w\$ \[\e[0m\]'
fi

# 12. Detect and correct accidental "cd" with no arguments
# If the user types 'cd' without arguments, this option makes it automatically go to the home directory.
shopt -s autocd
