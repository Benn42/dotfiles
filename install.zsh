#!/bin/zsh

# Function to clone a repository if it does not already exist
clone_repo() {
    local repo_url=$1
    local dest_dir=$2

    if [ ! -d "$dest_dir" ]; then
        echo "Cloning $repo_url to $dest_dir..."
        git clone "$repo_url" "$dest_dir"
    else
        echo "Directory $dest_dir already exists. Skipping clone."
    fi
}

# Clone the Zsh plugins
clone_repo "https://github.com/zsh-users/zsh-autosuggestions" "$HOME/.config/zsh/plugins/zsh-autosuggestions/"
clone_repo "https://github.com/marlonrichert/zsh-autocomplete.git" "$HOME/.config/zsh/plugins/zsh-autocomplete/"
clone_repo "https://github.com/zdharma-continuum/fast-syntax-highlighting" "$HOME/.config/zsh/plugins/fast-syntax-highlighting/"

# Copy the .zshrc file
if [ -f "./.zshrc" ]; then
    echo "Copying .zshrc to home directory..."
    cp ./.zshrc ~/.zshrc
else
    echo ".zshrc file not found in the current directory. Skipping copy."
fi

# Ensure the Starship config directory exists
mkdir -p ~/.config

# Copy the starship.toml file
if [ -f "./starship.toml" ]; then
    echo "Copying starship.toml to ~/.config..."
    cp ./starship.toml ~/.config/starship.toml
else
    echo "starship.toml file not found in the current directory. Skipping copy."
fi

# Source the .zshrc file
if [ -f "$HOME/.zshrc" ]; then
    echo "Sourcing ~/.zshrc..."
    source ~/.zshrc
else
    echo "~/.zshrc file not found. Unable to source."
fi

echo "Script execution completed."
