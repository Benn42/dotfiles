# Dot File Configuration

Easy managed setup of my dotfiles and configuration for Linux and WSL

## Required Packages

Install these packages first to give the full experience with the install tool

```bash
sudo apt-get install git-all exa bat zsh zoxide
```

```bash
curl -sS https://starship.rs/install.sh | sh
```

## Setup script usage

The setup script creates symlinks to configuration files for easy updates and can be used to conditionally configure different tools

```bash
./setup.sh -zstg -n "Your Name" -e "your.name@example.com" -c "code"
```

### Benefits of the symlink approach:
- Changes made in the repository are immediately available after sourcing
- Single source of truth for configuration files
- `.zshrc-local` file allows machine-specific configurations that won't be shared

## Legacy install script

The original install script (`install.sh`) is still available if you prefer file copying over symlinks.
