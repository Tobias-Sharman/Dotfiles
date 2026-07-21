# dotfiles

Personal macOS configuration, managed with [chezmoi](https://www.chezmoi.io/).

Made to ensure I can easily re-setup my device as I was burnt trying to port to using nix recently. As a comment on this, nix conceptually is great but some things that were important for my usage do not have the requisite polish for a clean setup.

## Bootstrap on a new machine

```bash
git clone git@github.com:Tobias-Sharman/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` installs Xcode Command Line Tools, Homebrew, all packages from the Brewfile, and applies every tracked config via chezmoi.

## Manual steps after bootstrap

A few things can't be automated and need doing by hand — `install.sh` prints these as a reminder at the end, but for reference:

1. Open 1Password -> Settings -> Developer -> enable "Use the SSH agent"
2. In your SSH key item, enable "Use with SSH agent" (Private vault)
3. Add your SSH public key to GitHub: Settings → SSH and GPG keys (get it with `ssh-add -L`)
4. Confirm SSH auth works: `ssh -T git@github.com`
5. Authenticate `gh` if needed: `gh auth login`
6. Open a fresh terminal or reload and source configuration so zsh plugins and starship pick up correctly
