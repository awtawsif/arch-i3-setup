#!/usr/bin/env bash

# ===== Performance Optimizations =====
# Reduce disk writes for history
export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%F %T "
export HISTIGNORE="ls:ll:cd:pwd:bg:fg:history:clear:exit"
shopt -s histappend
shopt -s cmdhist

# Disk IO optimizations
export FIGNORE='.o:~:.pyc'
export MAKEFLAGS="-j$(nproc)"

# Shell performance options
set -o noclobber              # Prevent file overwrite with >
shopt -s checkwinsize        # Update window size after each command
shopt -s no_empty_cmd_completion  # No empty command completion
shopt -s extglob             # Extended pattern matching

# ===== Visual Enhancements =====
# Colors and formatting
if [[ $TERM != "linux" && -x /usr/bin/tput ]]; then
    BOLD="$(tput bold)"
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    PURPLE="$(tput setaf 5)"
    CYAN="$(tput setaf 6)"
    WHITE="$(tput setaf 7)"
    RESET="$(tput sgr0)"
else
    BOLD="\e[1m"
    RED="\e[31m"
    GREEN="\e[32m"
    YELLOW="\e[33m"
    BLUE="\e[34m"
    PURPLE="\e[35m"
    CYAN="\e[36m"
    WHITE="\e[37m"
    RESET="\e[0m"
fi

# Beautiful minimal prompt with execution time
timer_start() {
    timer=${timer:-$SECONDS}
}

timer_stop() {
    local elapsed=$((SECONDS - timer))
    unset timer
    if [[ $elapsed -gt 2 ]]; then
        echo "${YELLOW}⏱ ${elapsed}s${RESET}"
    fi
}

trap 'timer_start' DEBUG
PROMPT_COMMAND="timer_stop"

# Minimal but informative prompt
PS1="\[${BOLD}${BLUE}\]┌─[\[${GREEN}\]\u\[${BLUE}\]]─[\[${CYAN}\]\w\[${BLUE}\]]\n\[${BLUE}\]└─\[${RESET}\]\[${BOLD}${PURPLE}\]λ\[${RESET}\] "

# ===== Environment Configuration =====
# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# Essential environment settings
export EDITOR="nano"
export TERM="alacritty"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ===== Modern Command Alternatives =====
# Use modern alternatives if available
if command -v exa &> /dev/null; then
    alias ls='exa --icons --group-directories-first'
    alias ll='exa -l --icons --group-directories-first --git'
    alias la='exa -la --icons --group-directories-first --git'
    alias lt='exa --tree --icons --level=2'
    alias l.='exa -a --icons | grep "^\."'
fi

if command -v bat &> /dev/null; then
    alias cat='bat --style=plain'
    alias less='bat --style=plain'
    export BAT_THEME="Dracula"
fi

# ===== Smart Aliases =====
# Colorize commands when possible
alias diff='diff --color=auto'
alias ip='ip -color=auto'
alias grep='grep --color=auto'

# Smart directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# Common operations with confirmation
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ln='ln -i'

# Powerpill shortcuts
alias ppup='sudo powerpill -Syu'
alias ppin='sudo powerpill -S'
alias pprem='sudo powerpill -Rns'
alias ppclean='sudo powerpill -Sc'
alias pporphan='sudo powerpill -Rns $(powerpill -Qtdq)'

# Pacman shortcuts
alias pacup='sudo pacman -Syu'
alias pacin='sudo pacman -S'
alias pacrem='sudo pacman -Rns'
alias pacsearch='pacman -Ss'
alias pacclean='sudo pacman -Sc'
alias pacorphan='sudo pacman -Rns $(pacman -Qtdq)'

# Package information
alias pkginfo='pacman -Qi'                      # Query installed package
alias pkgfile='pacman -Fl'                      # List remote package files
alias pkgcheck='pacman -Qk'                     # Check package files
alias pkgdeps='pacman -Qii'                     # Show package dependencies

# Git operation shortcuts
alias gitclone='git clone "https://github.com/$1/$2.git"'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold
blue)<%an>%Creset' --abbrev-commit --date=relative"

# ===== Functions =====
# Create and enter directory
mkcd() { mkdir -p "$1" && cd "$1"; }

# Smart archive extractor
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ===== Shell Options =====
# Better directory navigation
shopt -s autocd           # Change directory without cd
shopt -s dirspell        # Correct directory spelling
shopt -s cdspell         # Correct cd spelling
shopt -s globstar        # Enable ** glob pattern
shopt -s dotglob         # Include hidden files in globbing
shopt -s nocaseglob      # Case-insensitive globbing

# Bash completion settings
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# ===== Path Configuration =====
# Clean PATH to avoid duplicates
if [ -n "$PATH" ]; then
    old_PATH=$PATH:
    PATH=
    while [ -n "$old_PATH" ]; do
        x=${old_PATH%%:*}
        case $PATH: in
            *:"$x":*) ;;
            *) PATH=$PATH:$x;;
        esac
        old_PATH=${old_PATH#*:}
    done
    PATH=${PATH#:}
    unset old_PATH x
fi

export PATH="$HOME/.local/bin:$PATH"

# ===== Security =====
umask 077  # Set secure default permissions

# ===== Performance =====
# Disable flow control
stty -ixon  # Enable Ctrl+S for forward search

# Faster keyboard repeat rate (uncomment if needed)
# xset r rate 200 40  # Delay and rate

# Reduce disk writes
export LESSHISTFILE=/dev/null

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
