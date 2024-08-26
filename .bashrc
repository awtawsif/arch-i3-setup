# ~/.bashrc

# 1. Ensure the script is not run multiple times
if [ "$BASHRC_LOADED" ]; then
    return
fi
export BASHRC_LOADED=1

# 2. Prompt Customization: A colorful, informative prompt
PS1='\[\e[0;32m\]\u@\h:\[\e[0;34m\]\w\[\e[0;32m\]\n\$ \[\e[0m\]'

# Explanation:
# - \u: Username
# - \h: Hostname
# - \w: Current working directory
# - Colors:
#   - Green: \e[0;32m
#   - Blue: \e[0;34m
# - \n: Newline for prompt on the next line
# - \$: Shows $ for normal users, # for root

# 3. Color Definitions: Easy-to-use color variables for scripts
export BLACK='\e[0;30m'
export RED='\e[0;31m'
export GREEN='\e[1;32m'
export YELLOW='\e[0;33m'
export BLUE='\e[0;34m'
export MAGENTA='\e[0;35m'
export CYAN='\e[0;36m'
export WHITE='\e[0;37m'
export RESET='\e[0m'

# Usage Example:
alias success='echo -e "${GREEN}Success!${RESET}"'

# 4. Aliases: Shortcuts for common commands
alias ll='ls -alF --color=auto'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias cls='clear'

# 5. Directory Navigation: Quick navigation through directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# 6. Custom Functions: Enhance shell functionality

# Extract archives based on file extension
extract () {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.gz)  tar xzf $1 ;;
            *.bz2)     bunzip2 $1 ;;
            *.rar)     unrar x $1 ;;
            *.gz)      gunzip $1 ;;
            *.tar)     tar xf $1 ;;
            *.tbz2)    tar xjf $1 ;;
            *.tgz)     tar xzf $1 ;;
            *.zip)     unzip $1 ;;
            *.Z)       uncompress $1 ;;
            *.7z)      7z x $1 ;;
            *)         echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Search for a pattern in all files in a directory
function fgrep() {
    grep -r "$1" *
}

# 7. Environment Customizations: Set useful environment variables

# History Settings: Make history more useful
export HISTCONTROL=ignoreboth:erasedups  # Ignore duplicates and empty lines
export HISTSIZE=10000                    # History size
export HISTFILESIZE=20000                # History file size
shopt -s histappend                      # Append to the history file, don't overwrite

# Enable Autocorrect for minor mistakes
shopt -s cdspell

# 9. Terminal Features: Enhancements for terminal experience

# Enable programmable completion features
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# 11. PS1 Customization based on User
if [ "$USER" == "root" ]; then
    PS1='\[\e[1;31m\]\u@\h:\w# \[\e[0m\]'
else
    PS1='\[\e[1;32m\]\u@\h:\w\$ \[\e[0m\]'
fi

# 12. Detect and correct accidental "cd" with no arguments
shopt -s autocd
