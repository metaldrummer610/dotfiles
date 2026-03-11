#!/bin/bash
set -euo pipefail

info() {
  printf "\033[1;34m[dotfiles]\033[0m %s\n" "$1"
}

# On a mac
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  info "Detected macOS (Homebrew)"
  brew install zoxide fzf fd bat git-delta eza tldr nvim tmux font-jetbrains-mono-nerd-font ripgrep stow

else # On linux
  info "Detected Linux (apt)"
  sudo apt update
  sudo apt install -y zoxide fzf fd-find bat git-delta tldr neovim tmux ripgrep stow

  # Install eza from its dedicated repository
  if ! command -v eza &>/dev/null; then
    info "Installing eza..."
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
  fi

  # Install JetBrains Mono Nerd Font
  FONT_DIR="$HOME/.local/share/fonts"
  if [ ! -d "$FONT_DIR/JetBrainsMono" ]; then
    info "Installing JetBrains Mono Nerd Font..."
    mkdir -p "$FONT_DIR/JetBrainsMono"
    curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
      | tar -xJ -C "$FONT_DIR/JetBrainsMono"
    fc-cache -fv
  fi
fi

# Install Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  info "Installing Tmux Plugin Manager..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Deploy dotfiles with stow
info "Deploying dotfiles with stow..."
cd "$(dirname "$0")"
stow .

info "Done! Open a new zsh shell to complete Zinit plugin installation."
info "Then run 'tmux' and press prefix + I to install tmux plugins."
