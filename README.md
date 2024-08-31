# Dot File Configuration

Easy managed setup of my dotfiles and configuration for Linux and WSL

## Required Packages

Install these packages first to give the full experience with the install tool

```bash
sudo apt-get install git-all exa bat zsh
```

```bash
curl -sS https://starship.rs/install.sh | sh
```

## Install script usage

The install script can be used to conditionally configure different tools

```bash
./install.sh -zstg -n "Your Name" -e "your.name@example.com" -c "code"
```
