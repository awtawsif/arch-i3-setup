#!/usr/bin/env bash

PATH="$HOME/.local/bin:$PATH"
export npm_config_prefix="$HOME/.local"

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/share/nvm/nvm.sh" ] && \. "/usr/share/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/share/nvm/bash_completion" ] && \. "/usr/share/nvm/bash_completion"  # This loads nvm bash_completion

# Install and use the latest LTS version of Node.js automatically if not already installed
if ! nvm list | grep -q "lts"; then
  nvm install --lts
  nvm use --lts
fi