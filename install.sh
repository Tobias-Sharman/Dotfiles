#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"

info() { printf "\033[1;34m==>\033[0m %s\n" "$1"; }
warn() { printf "\033[1;33m==>\033[0m %s\n" "$1"; }
ok() { printf "\033[1;32m==>\033[0m %s\n" "$1"; }

if [[ "$(uname)" != "Darwin" ]]; then
	echo "This install script is macOS-only." >&2
	exit 1
fi

# -----------------------------------------------------------------------------
# Xcode Command Line Tools (needed before Homebrew)
# -----------------------------------------------------------------------------

if ! xcode-select -p >/dev/null 2>&1; then
	info "Installing Xcode Command Line Tools..."
	xcode-select --install
	warn "Finish the Xcode CLT install in the popup, then re-run this script."
	exit 0
else
	ok "Xcode Command Line Tools already installed."
fi

# -----------------------------------------------------------------------------
# Homebrew
# -----------------------------------------------------------------------------

if ! command -v brew >/dev/null 2>&1; then
	info "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	if [[ -x /opt/homebrew/bin/brew ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
else
	ok "Homebrew already installed."
fi

# -----------------------------------------------------------------------------
# Brewfile packages
# -----------------------------------------------------------------------------

info "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/dot_config/homebrew/Brewfile"

# -----------------------------------------------------------------------------
# Slang shader compiler (not available via Homebrew)
# -----------------------------------------------------------------------------
SLANG_INSTALL_DIR="$HOME/.local/slang"

if [[ -x "$SLANG_INSTALL_DIR/bin/slangc" ]]; then
	ok "Slang already installed."
else
	info "Installing Slang shader compiler..."

	SLANG_ARCH="$(uname -m)"
	if [[ "$SLANG_ARCH" == "arm64" ]]; then
		SLANG_ARCH="aarch64"
	fi

	SLANG_ASSET_URL="$(curl -fsSL https://api.github.com/repos/shader-slang/slang/releases/latest |
		grep "browser_download_url" |
		grep "macos-${SLANG_ARCH}\.tar\.gz" |
		grep -v "debug-info" |
		head -n1 |
		cut -d '"' -f4)"

	if [[ -z "$SLANG_ASSET_URL" ]]; then
		warn "Could not find a Slang release asset for macos-${SLANG_ARCH}. Skipping — install manually from https://github.com/shader-slang/slang/releases"
	else
		mkdir -p "$SLANG_INSTALL_DIR"
		curl -fsSL "$SLANG_ASSET_URL" | tar -xz -C "$SLANG_INSTALL_DIR" --strip-components=1
		ok "Slang installed to $SLANG_INSTALL_DIR"
	fi
fi

# -----------------------------------------------------------------------------
# Ansible collections
# -----------------------------------------------------------------------------
if command -v ansible-galaxy >/dev/null 2>&1; then
	info "Installing Ansible collections..."
	ansible-galaxy collection install community.crypto
else
	warn "ansible-galaxy not found — skipping collection install."
fi

# -----------------------------------------------------------------------------
# chezmoi apply
# -----------------------------------------------------------------------------

if ! command -v chezmoi >/dev/null 2>&1; then
	info "Installing chezmoi..."
	brew install chezmoi
fi

info "Applying dotfiles with chezmoi..."
chezmoi init --apply --source="$DOTFILES_DIR"

# -----------------------------------------------------------------------------
# Manual steps that can't be automated
# -----------------------------------------------------------------------------

echo
warn "Automated setup is done. A few things still need doing by hand:"
echo
echo "  1. Open 1Password -> Settings -> Developer -> enable 'Use the SSH agent'"
echo "  2. In that same key item, enable 'Use with SSH agent' and confirm it's in agent.toml's Private vault"
echo "  3. Add your SSH public key to GitHub: Settings -> SSH and GPG keys"
echo "     (get it with: ssh-add -L)"
echo "  4. Confirm SSH auth works: ssh -T git@github.com"
echo "  5. Authenticate gh if needed: gh auth login"
echo "  6. Open a fresh terminal so zsh plugins and starship pick up correctly"
echo

ok "Bootstrap complete."
