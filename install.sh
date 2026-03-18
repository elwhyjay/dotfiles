#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"
cd "$DOTFILES"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[✓]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
err()     { echo -e "${RED}[✗]${NC} $1"; }
skip()    { echo -e "    $1 (already exists, skipping)"; }
section() { echo -e "\n${GREEN}=== $1 ===${NC}"; }

# ─────────────────────────────────────────────
# OS detection
# ─────────────────────────────────────────────

OS="$(uname -s)"
case "$OS" in
  Darwin) OS="mac" ;;
  Linux)  OS="linux" ;;
  *)      err "Unsupported OS: $OS"; exit 1 ;;
esac
info "Detected OS: $OS"

# Package manager helper
pkg_install() {
  local name="$1"
  if command -v "$name" &>/dev/null; then
    skip "$name"
    return
  fi
  if [ "$OS" = "mac" ]; then
    brew install "$name"
  else
    sudo apt-get install -y "$name"
  fi
  info "Installed $name"
}

# ─────────────────────────────────────────────
section "Symlinks"
# ─────────────────────────────────────────────

link() {
  local src="$DOTFILES/$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    skip "$dst"
  elif [ -e "$dst" ]; then
    warn "$dst exists and is not a symlink — backing up to ${dst}.bak"
    mv "$dst" "${dst}.bak"
    ln -s "$src" "$dst"
    info "$dst -> $src (backup created)"
  else
    ln -s "$src" "$dst"
    info "$dst -> $src"
  fi
}

link .zshrc        "$HOME/.zshrc"
link .bashrc       "$HOME/.bashrc"
link .bash_profile "$HOME/.bash_profile"
link .vimrc        "$HOME/.vimrc"
link .tmux.conf    "$HOME/.tmux.conf"
link init.vim      "$HOME/.config/nvim/init.vim"
link coc-settings.json "$HOME/.config/nvim/coc-settings.json"

# ─────────────────────────────────────────────
section "Package manager"
# ─────────────────────────────────────────────

if [ "$OS" = "mac" ]; then
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    skip "Homebrew"
  fi
else
  info "Updating apt..."
  sudo apt-get update -qq
fi

# ─────────────────────────────────────────────
section "Core packages"
# ─────────────────────────────────────────────

if [ "$OS" = "mac" ]; then
  PACKAGES=(
    # Core
    neovim tmux zsh fzf ripgrep
    zsh-syntax-highlighting powerlevel10k
    # Modern CLI
    bat lsd fd btop httpie tree wget jq
    # Development
    node yarn go llvm universal-ctags cmake zig uv ruff direnv
    # Media
    ffmpeg hugo
  )
  for pkg in "${PACKAGES[@]}"; do
    if brew list "$pkg" &>/dev/null; then
      skip "$pkg"
    else
      info "Installing $pkg..."
      brew install "$pkg"
    fi
  done
else
  # ── Linux (apt) ──
  # Core
  APT_PACKAGES=(
    zsh tmux fzf ripgrep
    zsh-syntax-highlighting
    # Modern CLI
    bat fd-find jq tree wget curl httpie
    # Development
    nodejs npm yarnpkg golang-go cmake universal-ctags direnv
    # Media
    ffmpeg hugo
  )
  sudo apt-get install -y "${APT_PACKAGES[@]}"

  # Packages not in apt or need newer versions
  # neovim (apt version is often outdated)
  if ! command -v nvim &>/dev/null; then
    info "Installing Neovim (appimage)..."
    curl -fLo /tmp/nvim.appimage https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x /tmp/nvim.appimage
    sudo mv /tmp/nvim.appimage /usr/local/bin/nvim
  else
    skip "neovim"
  fi

  # lsd
  if ! command -v lsd &>/dev/null; then
    info "Installing lsd..."
    cargo install lsd 2>/dev/null || sudo apt-get install -y lsd 2>/dev/null || warn "lsd: install manually"
  else
    skip "lsd"
  fi

  # btop
  pkg_install btop

  # zig
  if ! command -v zig &>/dev/null; then
    warn "zig: install manually from https://ziglang.org/download/"
  else
    skip "zig"
  fi

  # uv
  if ! command -v uv &>/dev/null; then
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
  else
    skip "uv"
  fi

  # ruff
  if ! command -v ruff &>/dev/null; then
    info "Installing ruff..."
    curl -LsSf https://astral.sh/ruff/install.sh | sh
  else
    skip "ruff"
  fi

  # powerlevel10k
  P10K_DIR="${HOME}/.powerlevel10k"
  if [ ! -d "$P10K_DIR" ]; then
    info "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  else
    skip "powerlevel10k"
  fi

  # llvm/clangd
  pkg_install clangd
fi

# ─────────────────────────────────────────────
section "Neovim (vim-plug)"
# ─────────────────────────────────────────────

PLUG_PATH="$HOME/.local/share/nvim/site/autoload/plug.vim"
if [ ! -f "$PLUG_PATH" ]; then
  info "Installing vim-plug..."
  curl -fLo "$PLUG_PATH" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  skip "vim-plug"
fi

info "Installing nvim plugins..."
nvim --headless +PlugInstall +qall 2>/dev/null || warn "PlugInstall had warnings (run manually if needed)"

# ─────────────────────────────────────────────
section "tmux (TPM)"
# ─────────────────────────────────────────────

TPM_PATH="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_PATH" ]; then
  info "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_PATH"
else
  skip "TPM"
fi

# ─────────────────────────────────────────────
section "NVM"
# ─────────────────────────────────────────────

if [ ! -d "$HOME/.nvm" ]; then
  info "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
  skip "NVM"
fi

# ─────────────────────────────────────────────
section "Rust"
# ─────────────────────────────────────────────

if ! command -v rustup &>/dev/null; then
  info "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
  skip "Rust"
fi

# ─────────────────────────────────────────────
section "Fonts (Nerd Font)"
# ─────────────────────────────────────────────

if [ "$OS" = "mac" ]; then
  if ! brew list --cask font-hack-nerd-font &>/dev/null 2>&1; then
    info "Installing Nerd Font..."
    brew install --cask font-hack-nerd-font
  else
    skip "Nerd Font"
  fi
else
  FONT_DIR="$HOME/.local/share/fonts"
  if [ ! -f "$FONT_DIR/HackNerdFont-Regular.ttf" ]; then
    info "Installing Nerd Font..."
    mkdir -p "$FONT_DIR"
    curl -fLo /tmp/Hack.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz
    tar -xf /tmp/Hack.tar.xz -C "$FONT_DIR"
    fc-cache -fv "$FONT_DIR" >/dev/null 2>&1
    rm /tmp/Hack.tar.xz
  else
    skip "Nerd Font"
  fi
fi

# ─────────────────────────────────────────────
section "Done"
# ─────────────────────────────────────────────

echo ""
info "Setup complete! ($OS)"
echo ""
warn "Manual steps:"
echo "  1. Restart terminal (or: exec zsh)"
echo "  2. Run 'p10k configure' for Powerlevel10k setup"
echo "  3. Open tmux -> prefix + I to install tmux plugins"
echo "  4. nvim -> :PlugInstall if plugins didn't install"
echo "  5. Optional: conda, ghcup (install as needed)"
echo ""
