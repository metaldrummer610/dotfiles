#!/bin/bash
set -euo pipefail

info() {
  printf "\033[1;34m[dotfiles]\033[0m %s\n" "$1"
}

# On a mac
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  info "Detected macOS (Homebrew)"
  brew install zoxide fzf fd bat git-delta eza tldr nvim tmux font-jetbrains-mono-nerd-font ripgrep stow \
    yazi btop mise dust sd hyperfine ghostty \
    difftastic ast-grep buf golangci-lint grpcurl jless glow lazydocker lazygit

else # On linux
  info "Detected Linux (apt)"
  sudo apt update
  sudo apt install -y zoxide fzf fd-find bat git-delta tldr neovim tmux ripgrep stow \
    btop du-dust hyperfine

  # Install eza from its dedicated repository
  if ! command -v eza &>/dev/null; then
    info "Installing eza..."
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
  fi

  # Install tools via curl/cargo/go installers
  if ! command -v mise &>/dev/null; then
    info "Installing mise..."
    curl https://mise.run | sh
  fi

  if command -v cargo &>/dev/null; then
    info "Installing Rust-based tools via cargo..."
    cargo install --locked yazi-fm yazi-cli 2>/dev/null || true
    cargo install sd difftastic ast-grep jless 2>/dev/null || true
  fi

  if command -v go &>/dev/null; then
    info "Installing Go-based tools..."
    go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
    go install github.com/charmbracelet/glow@latest
    go install github.com/jesseduffield/lazydocker@latest
    go install github.com/jesseduffield/lazygit@latest
  fi

  if ! command -v golangci-lint &>/dev/null && command -v go &>/dev/null; then
    info "Installing golangci-lint..."
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b "$(go env GOPATH)/bin"
  fi

  if ! command -v buf &>/dev/null; then
    info "Installing buf..."
    curl -sSL "https://github.com/bufbuild/buf/releases/latest/download/buf-$(uname -s)-$(uname -m)" -o /usr/local/bin/buf && chmod +x /usr/local/bin/buf
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
