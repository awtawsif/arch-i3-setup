# ~/.bashrc

# ----------------------------
# 1. Environment Settings
# ----------------------------

# Set default editor to vim or nano
export EDITOR=nano

# Enable color support for ls and grep
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Set language and locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Increase bash history size
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups  # Avoid duplicate entries
shopt -s histappend  # Append to history, don't overwrite it

# Enable recursive globbing (**)
shopt -s globstar

# Case-insensitive tab completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "set completion-map-case on"

# ----------------------------
# 2. Aliases
# ----------------------------

# Common shortcuts
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias h='history'
alias e='exit'
alias mkdir='mkdir -p'
alias rmd='rm -rf'
alias v='vim'
alias df='df -h'
alias du='du -h'
alias free='free -m'

# Pacman package management
alias pacup='sudo pacman -Syu'  # Update system
alias paci='sudo pacman -S'     # Install package
alias pacr='sudo pacman -Rns'   # Remove package
alias pacq='pacman -Qe'         # List explicitly installed packages
alias pacs='pacman -Ss'         # Search for a package

# AUR helper
alias yay='yay'
alias aurs='yay -Ss'           # Search AUR
alias auri='yay -S'            # Install from AUR

# ----------------------------
# 4. Functions
# ----------------------------

# Quick directory navigation
mkcd() {
  mkdir -p "$1"
  cd "$1"
}

# Extract any compressed file
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar xjf "$1" ;;
      *.tar.gz)   tar xzf "$1" ;;
      *.bz2)      bunzip2 "$1" ;;
      *.rar)      unrar x "$1" ;;
      *.gz)       gunzip "$1" ;;
      *.tar)      tar xvf "$1" ;;
      *.tbz2)     tar xjf "$1" ;;
      *.tgz)      tar xzf "$1" ;;
      *.zip)      unzip "$1" ;;
      *.Z)        uncompress "$1" ;;
      *.7z)       7z x "$1" ;;
      *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Kill a process by name
killbyname() {
  pkill -f "$1"
}

# Quickly open i3 config
i3conf() {
  $EDITOR ~/.config/i3/config
  i3-msg reload
}

# Toggle touchpad (for laptops)
toggle_touchpad() {
  if xinput list-props "SynPS/2 Synaptics TouchPad" | grep "Device Enabled.*1" > /dev/null
  then
    xinput disable "SynPS/2 Synaptics TouchPad"
    notify-send "Touchpad Disabled"
  else
    xinput enable "SynPS/2 Synaptics TouchPad"
    notify-send "Touchpad Enabled"
  fi
}

# ----------------------------
# 5. Source other config files
# ----------------------------

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Load user-specific bash completions, if available
if [ -f ~/.bash_completion ]; then
    . ~/.bash_completion
fi

# ----------------------------
# 6. Final Touches
# ----------------------------

# Source custom scripts if they exist
if [ -f ~/custom_scripts.sh ]; then
    source ~/custom_scripts.sh
fi

# Enable alias expansion in non-interactive shells
shopt -s expand_aliases
