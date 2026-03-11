# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("/Users/rdiaz/.oh-my-zsh/custom/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# XDG Base Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light MichaelAquilina/zsh-you-should-use
zinit light fdellwing/zsh-bat

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt auto_cd
setopt correct
setopt interactive_comments

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='eza --color=always --icons'
alias ll='eza -la --icons --git'
alias la='eza -a --icons'
alias lt='eza --tree --level=2 --icons'
alias vim='nvim'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias c='clear'
alias t='tmux'
alias ta='tmux attach'
alias top='btop'
alias du='dust'
alias cat='bat'
alias lg='lazygit'
alias lzd='lazydocker'
alias md='glow'

# Yazi file manager wrapper (changes CWD on exit)
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(atuin init zsh)"
eval "$(mise activate zsh)"
source ~/.git-commands.zsh

export PATH=$PATH:~/bin

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/rdiaz/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

alias cs='commitsmith'
eval "$(direnv hook zsh)"

export HOMEBREW_ARTIFACT_DOMAIN="https://REDACTED_ARTIFACTORY_HOST/artifactory/github-docker-external-remote"
export HOMEBREW_BOTTLE_DOMAIN="https://REDACTED_ARTIFACTORY_HOST/artifactory/github-docker-external-remote"
export HOMEBREW_DOCKER_REGISTRY_TOKEN="REDACTED_HOMEBREW_DOCKER_REGISTRY_TOKEN" # select docker>github-docker-external-remote in artifactory set me up

# don't call api every time (get past connection reset)
# https://apple.stackexchange.com/questions/457385/how-to-stop-brew-downloading-the-formula-each-time-when-using-services-command
export HOMEBREW_NO_INSTALL_FROM_API=1
export ARTIFACTORY_PAT=REDACTED_ARTIFACTORY_PAT

# pnpm
export PNPM_HOME="/Users/rdiaz/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Added by Windsurf
export PATH="/Users/rdiaz/.codeium/windsurf/bin:$PATH"
#export DOCKER_HOST=unix://$HOME/.rd/docker.sock
#export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
#export TESTCONTAINERS_HOST_OVERRIDE=$(rdctl shell ip a show vznat | awk '/inet / {sub("/.*",""); print $2}')

export PATH="/Users/rdiaz/go/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

export GEMINI_API_KEY="REDACTED_GEMINI_API_KEY"

export PATH="$HOME/.local/bin:$PATH"

#export NODE_EXTRA_CA_CERTS="$HOME/.certs/echo-root.pem"
#export SSL_CERT_FILE="$HOME/.certs/echo-root.pem"
