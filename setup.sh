#!/bin/bash

# On a mac
if [[ -f "/opt/homebrew/bin/brew" ]]; then
	brew install zoxide fzf fd bat git-delta eza tldr nvim tmux font-jetbrains-mono-nerd-font ripgrep
else # On linux
	apt install zoxide fzf fd bat delta eza tldr nvim tmux
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
