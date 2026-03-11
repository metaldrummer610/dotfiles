# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Included

- **Zsh** — Zinit plugin manager, Powerlevel10k prompt, fzf-tab completion, syntax highlighting, autosuggestions
- **Neovim** — Lua-based config with Lazy.nvim, LSP (Mason), blink.cmp completion, Telescope, Treesitter, format-on-save
- **Tmux** — Ctrl-A prefix, vi copy mode, tmux-resurrect/continuum, Tokyo Night theme
- **Git** — Delta pager (side-by-side diffs), sensible defaults, global gitignore
- **EditorConfig** — Consistent formatting defaults across editors

## Quick Start

```bash
git clone https://github.com/metaldrummer610/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The setup script will:
1. Install dependencies via Homebrew (macOS) or apt (Linux)
2. Install JetBrains Mono Nerd Font (Linux)
3. Install Tmux Plugin Manager
4. Deploy all configs to `$HOME` via `stow`

After setup, open a new Zsh shell to trigger Zinit plugin installation, then run `tmux` and press `prefix + I` to install tmux plugins.

## Supported Platforms

- **macOS** — via Homebrew
- **Linux** — via apt (Debian/Ubuntu)

## Languages & Tools Configured

LSP servers, formatters, and linters are auto-installed by Mason for:

Go, TypeScript/JavaScript, Python, Lua, HTML/CSS, Tailwind, Svelte, GraphQL, Prisma, Docker, Bazel

## Customization

- Git user/email: `git config --global user.name "Your Name"` and `git config --global user.email "you@example.com"`
- Zsh prompt: Run `p10k configure` to reconfigure Powerlevel10k
- Neovim plugins: Edit files in `.config/nvim/lua/metaldrummer610/plugins/`
