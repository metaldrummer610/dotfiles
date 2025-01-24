#!/bin/bash

# On a mac
if [[ -f "/opt/homebrew/bin/brew" ]]; then
	brew install zoxide fzf fd bat git-delta eza tldr nvim tmux font-jetbrains-mono-nerd-font ripgrep stow
else # On linux
	sudo apt install zoxide fzf fd-find bat delta tldr neovim tmux

  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update
  sudo apt install -y eza
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
