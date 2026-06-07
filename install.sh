#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# macOS Dev Environment Setup & Config Sync
# Source: ~/.config/macos_dev_enviroment
# ============================================================

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config/macos_dev_enviroment-backup-$(date +%Y%m%d-%H%M%S)"

# ── Utils ──────────────────────────────────────────────────
info()  { printf "\033[1;34m➜\033[0m %s\n" "$*"; }
ok()    { printf "\033[1;32m✔\033[0m %s\n" "$*"; }
warn()  { printf "\033[1;33m⚠\033[0m %s\n" "$*"; }
backup() {
  local src="$1"
  if [ -e "$src" ]; then
    local dest="$BACKUP_DIR/$src"
    mkdir -p "$(dirname "$dest")"
    cp -Rf "$src" "$dest"
    warn "Backed up $src → $dest"
  fi
}

# ── 1. Install Homebrew ────────────────────────────────────
install_homebrew() {
  if command -v brew &>/dev/null; then
    ok "Homebrew already installed"
  else
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ok "Homebrew installed"
  fi
}

# ── 2. Install packages from README groups ─────────────────
# --- Auto-installed via brew (formulae = CLI tools) ---
BREW_FORMULAE=(
  aerospace bat btop delta fd fzf gh jq lazygit mise neovim
  ripgrep sketchybar starship thefuck tldr zoxide
)
# --- Auto-installed via brew (casks = GUI apps) ---
BREW_CASKS=(
  balenaetcher brave-browser discord docker drawio firefox
  ghostty google-chrome hiddenbar insomnia karabiner-elements
  languagetool obs openemu raycast rectangle slack steam
  telegram vlc warp whatsapp zed
)

# --- Requires SetApp subscription ---
SETAPP_APPS=(
  "AlDente Pro" "Archiver" "Backtrack" "Be Focused" "CleanMyMac"
  "CleanShot X" "Dash" "DevUtils" "Diagrams" "Downie" "Elephas"
  "Folx" "ForkLift" "Gemini" "iBoysoft Data Recovery"
  "iBoysoft NTFS for Mac" "In Your Face" "iStat Menus"
  "KeyKey Typing Tutor" "Lungo" "MetaImage" "Mockuuups Studio"
  "Nitro PDF Pro" "Permute" "PixelSnap" "SideNotes" "Sip"
  "TablePlus" "TextSniper" "TouchRetouch"
)

# --- Manual download only (not in brew) ---
declare -A MANUAL_DOWNLOAD
MANUAL_DOWNLOAD["DisplayLink Driver"]="https://www.synaptics.com/products/displaylink-graphics/downloads/macos"
MANUAL_DOWNLOAD["GameHub"]="https://www.gamemac.com/en"
MANUAL_DOWNLOAD["SocialFocus"]="https://socialfocus.app/"
MANUAL_DOWNLOAD["Dank Mono (paid font)"]="https://philpl.gumroad.com/l/dank-mono"

install_brew_packages() {
  info "Installing brew formulae..."
  for pkg in "${BREW_FORMULAE[@]}"; do
    if brew list --formula "$pkg" &>/dev/null 2>&1; then
      ok "$pkg already installed"
    else
      brew install "$pkg"
      ok "$pkg installed"
    fi
  done

  info "Installing brew casks..."
  for pkg in "${BREW_CASKS[@]}"; do
    if brew list --cask "$pkg" &>/dev/null 2>&1; then
      ok "$pkg already installed"
    else
      brew install --cask "$pkg"
      ok "$pkg installed"
    fi
  done
}

# ── 3. Install Oh My Zsh ───────────────────────────────────
install_ohmyzsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    ok "Oh My Zsh already installed"
  else
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    ok "Oh My Zsh installed"
  fi
}

# ── 4. Install fonts ───────────────────────────────────────
install_fonts() {
  info "Installing JetBrains Mono Nerd Font..."
  if [ ! -f "$HOME/Library/Fonts/JetBrainsMonoNerdFont-Regular.ttf" ]; then
    brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || true
    if [ -f "$HOME/Library/Fonts/JetBrainsMonoNerdFont-Regular.ttf" ]; then
      ok "JetBrains Mono Nerd Font installed"
    else
      warn "Font install failed — install manually: brew install --cask font-jetbrains-mono-nerd-font"
    fi
  else
    ok "JetBrains Mono Nerd Font already present"
  fi

  info "Installing sketchybar-app-font..."
  if [ ! -f "$FONT_DIR/sketchybar-app-font.ttf" ]; then
    curl -fsSL "https://github.com/kvndrsslr/sketchybar-app-font/releases/latest/download/sketchybar-app-font.ttf" \
      -o "$FONT_DIR/sketchybar-app-font.ttf"
    ok "sketchybar-app-font installed"
  else
    ok "sketchybar-app-font already present"
  fi
}

# ── 5. Copy configs to their targets ───────────────────────
sync_configs() {
  info "Syncing config files..."

  # Aerospace → ~/.config/aerospace/aerospace.toml
  backup "$HOME/.config/aerospace/aerospace.toml"
  mkdir -p "$HOME/.config/aerospace"
  cp "$REPO_DIR/Aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
  ok "Aerospace config deployed"

  # Btop → ~/.config/btop/btop.conf
  backup "$HOME/.config/btop/btop.conf"
  mkdir -p "$HOME/.config/btop"
  cp "$REPO_DIR/Btop/btop.conf" "$HOME/.config/btop/btop.conf"
  ok "Btop config deployed"

  # Ghostty → ~/.config/ghostty/config
  backup "$HOME/.config/ghostty/config"
  mkdir -p "$HOME/.config/ghostty"
  cp "$REPO_DIR/Ghostty/config" "$HOME/.config/ghostty/config"
  ok "Ghostty config deployed"

  # Lazygit → ~/Library/Application Support/lazygit/config.yml
  backup "$HOME/Library/Application Support/lazygit/config.yml"
  mkdir -p "$HOME/Library/Application Support/lazygit"
  cp "$REPO_DIR/LazyGit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"
  ok "Lazygit config deployed"

  # Sketchybar → ~/.config/sketchybar/ (full directory tree)
  backup "$HOME/.config/sketchybar"
  rm -rf "$HOME/.config/sketchybar"
  cp -R "$REPO_DIR/Sketchybar/sketchybar" "$HOME/.config/sketchybar"
  find "$HOME/.config/sketchybar" -name "*.sh" -exec chmod +x {} \;
  ok "Sketchybar config deployed"

  # Starship → ~/.config/starship.toml
  backup "$HOME/.config/starship.toml"
  cp "$REPO_DIR/Starship/starship.toml" "$HOME/.config/starship.toml"
  ok "Starship config deployed"

  # Zed → ~/.config/zed/settings.json
  backup "$HOME/.config/zed/settings.json"
  mkdir -p "$HOME/.config/zed"
  cp "$REPO_DIR/Zed/settings.json" "$HOME/.config/zed/settings.json"
  ok "Zed config deployed"

  # ZSH → ~/.zshrc
  backup "$HOME/.zshrc"
  cp "$REPO_DIR/ZSH/.zshrc" "$HOME/.zshrc"
  ok ".zshrc deployed"

  # OpenCode → ~/.config/opencode/AGENTS.md
  backup "$HOME/.config/opencode/AGENTS.md"
  mkdir -p "$HOME/.config/opencode"
  cp "$REPO_DIR/Opencode/AGENTS.md" "$HOME/.config/opencode/AGENTS.md"
  ok "OpenCode AGENTS.md deployed"
}

# ── 6. Install LazyVim (neovim distro) ────────────────────
install_lazyvim() {
  if [ -d "$HOME/.config/nvim" ]; then
    ok "LazyVim already installed"
  else
    info "Installing LazyVim..."
    git clone https://github.com/LazyVim/LazyVim.git "$HOME/.config/nvim" 2>/dev/null || true
    ok "LazyVim installed (run nvim to finish setup)"
  fi
}

# ── 7. Post-install setup ──────────────────────────────────
post_install() {
  info "Running post-install setup..."

  # Starship shell integration (zsh)
  if ! grep -q 'starship init zsh' "$HOME/.zshrc" 2>/dev/null; then
    echo '' >> "$HOME/.zshrc"
    echo '# Starship prompt' >> "$HOME/.zshrc"
    echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
    ok "Starship init added to .zshrc"
  fi

  # Start services
  if command -v aerospace &>/dev/null; then
    info "Starting AeroSpace... (you may need to grant permissions)"
    aerospace &>/dev/null || true
  fi

  if command -v sketchybar &>/dev/null; then
    info "Reloading SketchyBar..."
    sketchybar --reload 2>/dev/null || true
  fi

  # Setup fzf
  if command -v fzf &>/dev/null; then
    if ! grep -q 'fzf --zsh' "$HOME/.zshrc" 2>/dev/null; then
      "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc 2>/dev/null || true
      ok "fzf shell integration installed"
    fi
  fi

  info "Post-install setup complete"
}

# ── Main ────────────────────────────────────────────────────
main() {
  echo ""
  printf "\033[1;36m╔══════════════════════════════════════════════╗\033[0m\n"
  printf "\033[1;36m║   macOS Dev Environment Setup & Config Sync  ║\033[0m\n"
  printf "\033[1;36m╚══════════════════════════════════════════════╝\033[0m\n"
  echo ""

  install_homebrew
  install_brew_packages
  install_ohmyzsh
  install_fonts
  sync_configs
  install_lazyvim
  post_install

  echo ""
  ok "All done!"
  info "Backups saved to: $BACKUP_DIR"
  info "Some changes require restarting your terminal/shell."
  info ""
  printf "\033[1;33m── Manual steps ──────────────────────────────\033[0m\n"
  info "1. Restart terminal or run: source ~/.zshrc"
  info "2. Grant accessibility permissions for AeroSpace & SketchyBar"
  info ""
  printf "\033[1;33m── SetApp apps (install via SetApp subscription) ─\033[0m\n"
  for app in "${SETAPP_APPS[@]}"; do
    info "  • $app"
  done
  info ""
  printf "\033[1;33m── Manual download only ───────────────────────\033[0m\n"
  for app in "${!MANUAL_DOWNLOAD[@]}"; do
    info "  • $app → ${MANUAL_DOWNLOAD[$app]}"
  done
  info ""
  printf "\033[1;33m── Install via Raycast store ──────────────────\033[0m\n"
  info "  • Brew, CleanShot X, Coffee, Docker, GitHub"
  info "  • Manage Services, Random Data Generator, Remove Paywall"
  info "  • Search HTTP Status Codes, Search npm Packages, Sip"
  info "  • Slack, TablePlus, Tailwind CSS, Test Internet Speed"
  info "  • Zed, Vim Commands"
  info ""
  printf "\033[1;33m── CLI tools to install manually ───────────────\033[0m\n"
  info "  • Claude Code → npm install -g @anthropic-ai/claude-code"
  info "  •     Then add: andrej-karpathy-skills + caveman skills"
  info "  • Open Code   → brew install opencode"
  info "  •     Then add: andrej-karpathy-skills + caveman skills"
  echo ""
}

main "$@"
