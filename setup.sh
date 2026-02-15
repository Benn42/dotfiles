#!/bin/bash

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

# Function to create symlinks with backup and error handling
create_symlink() {
    local source_file=$1
    local target_file=$2
    
    # Validate source file exists
    if [ ! -f "$(pwd)/$source_file" ]; then
        echo "Error: Source file $source_file not found in repository"
        exit 1
    fi
    
    # Backup existing file if it exists
    if [ -e "$target_file" ] || [ -L "$target_file" ]; then
        echo "Backing up existing $target_file to $target_file.bak"
        mv "$target_file" "$target_file.bak"
    fi
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$target_file")"
    
    # Create absolute path symlink
    ln -s "$(pwd)/$source_file" "$target_file"
    echo "Created symlink: $target_file -> $(pwd)/$source_file"
}

# Function to create local config files
create_local_config() {
    local local_file=$1
    if [ ! -f "$local_file" ]; then
        echo "# Can be used for machine specific config that is not shared across environments" > "$local_file"
        echo "Created local config file: $local_file"
    fi
}

# Function to backup files/directories to OpenCode backup folder with timestamp
backup_to_opencode_backup() {
    local target_path=$1
    local backup_dir="$HOME/.config/opencode/.backup"
    
    # Skip if target is already a symlink (no backup needed)
    if [ -L "$target_path" ]; then
        return 0
    fi
    
    # Skip if target doesn't exist
    if [ ! -e "$target_path" ]; then
        return 0
    fi
    
    # Create backup directory if it doesn't exist
    mkdir -p "$backup_dir"
    
    # Generate timestamp
    local timestamp=$(date +%Y-%m-%d_%H-%M-%S)
    local item_name=$(basename "$target_path")
    local backup_path="$backup_dir/${item_name}.${timestamp}"
    
    # Move to backup
    echo "Backing up existing $target_path to $backup_path"
    mv "$target_path" "$backup_path"
}

# Function to create symlinks for OpenCode configuration
create_opencode_symlink() {
    local source_item=$1
    local target_path=$2
    
    # Validate source exists
    if [ ! -e "$(pwd)/$source_item" ]; then
        echo "Error: Source $source_item not found in repository"
        exit 1
    fi
    
    # Check if target is already correctly symlinked
    if [ -L "$target_path" ]; then
        local current_target=$(readlink "$target_path")
        local expected_target="$(pwd)/$source_item"
        if [ "$current_target" = "$expected_target" ]; then
            echo "Symlink already correct: $target_path -> $expected_target"
            return 0
        else
            # Remove incorrect symlink
            echo "Removing incorrect symlink: $target_path -> $current_target"
            rm "$target_path"
        fi
    fi
    
    # Backup existing item if needed (only backs up non-symlinks)
    backup_to_opencode_backup "$target_path"
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$target_path")"
    
    # Create absolute path symlink
    ln -s "$(pwd)/$source_item" "$target_path"
    echo "Created symlink: $target_path -> $(pwd)/$source_item"
}

usage() {
    cat << EOL
Usage: $0 [-g -e your.name@example.com -n \"Your name\" -p path/to/.ssh/your.pub [-c youreditor]] [-t] [-s] [-z] [-o]
-g Flags to configure .gitconfig
    -e Github Email global config
    -n Github Name global config
    -p Github ssh key path global config
    -c Github editor global config
-t Flags to configure tmux
-s Flags to configure starship
-z Flags to configure zsh
-o Flags to configure opencode
EOL
}

while getopts ":gtsoe:n:p:c:h" o; do
    case "${o}" in
        g)
            git=true
            ;;
        t)
            tmux=true
            ;;
        s)
            starship=true
            ;;
        z)
            zsh=true
            ;;
        o)
            opencode=true
            ;;
        e)
            email=${OPTARG}
            regex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"
            if ! [[ $email =~ $regex ]]; then
                echo "Invalid email address passed"
                exit 1
            fi
            ;;
        n)
            name=${OPTARG}
            ;;
        p)
            path=${OPTARG}
            ;;
        c)
            editor=${OPTARG}
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

if [ $git ]; then
    if ! [[ $email && $name && $path ]]; then
        usage
    else
        echo "Installing .gitconfig..."
        if ! [ $editor ]; then
            editor="nvim -f"
        fi

        read -r -d '' GITCONF << EOM
[init]
	defaultBranch = main
[user]
	name = $name
	email = $email
	signingkey = $path
[alias]
	st = status -s
	sta = status
	conf = config --global --edit
	ci = commit
	co = checkout
	rh = reset HEAD
	aa = add -A
	br = branch
	bra = branch -a
	pr = pull --rebase
	amend = commit -a --amend --no-edit
	ciam = commit -a --amend --no-edit
[push]
	autoSetupRemote = true
[core]
	editor = $editor
[gpg]
	format = ssh
[commit]
	gpgsign = true
EOM

        echo "$GITCONF" > $HOME/.gitconfig
    fi
fi

# Ensure config directory exists
mkdir -p $HOME/.config

if [ $tmux ] && [ -x "$(which tmux)" ]; then
    clone_repo "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"

    create_symlink "./tmux.conf" "$HOME/.config/tmux/tmux.conf"

    if [ "$TERM_PROGRAM" != "tmux" ]; then
        echo 'Starting tmux...'
        tmux
    else
        echo 'Sourcing tmux config...'
        tmux source $HOME/.config/tmux/tmux.conf
    fi
fi

# Create symlink for starship.toml file
if [ $starship ]; then
    echo "Creating symlink for starship.toml to $HOME/.config..."
    create_symlink "./starship.toml" "$HOME/.config/starship.toml"
fi

if [ $zsh ]; then
    echo "Installing zsh config..."

    # Create symlink for .zshrc file
    if [ -f "./.zshrc" ]; then
        echo "Creating symlink for .zshrc to home directory..."
        create_symlink "./.zshrc" "$HOME/.zshrc"

        # Clone the Zsh plugins
        clone_repo "https://github.com/zsh-users/zsh-autosuggestions" "$HOME/.config/zsh/plugins/zsh-autosuggestions/"
        clone_repo "https://github.com/marlonrichert/zsh-autocomplete.git" "$HOME/.config/zsh/plugins/zsh-autocomplete/"
        clone_repo "https://github.com/zdharma-continuum/fast-syntax-highlighting" "$HOME/.config/zsh/plugins/fast-syntax-highlighting/"
    else
        echo ".zshrc file not found in the current directory. Skipping symlink creation."
        exit 1
    fi

    # Create symlink for .zprofile file
    if [ -f "./.zprofile" ]; then
        echo "Creating symlink for .zprofile to home directory..."
        create_symlink "./.zprofile" "$HOME/.zprofile"
    else 
        echo ".zprofile file not found in the current directory. Skipping symlink creation."
        exit 1
    fi

    # Create local .zshrc-local file
    create_local_config "$HOME/.zshrc-local"

    # Source the .zshrc file
    if [ -f "$HOME/.zshrc" ]; then
        echo "Sourcing $HOME/.zshrc..."
        exec /bin/zsh
        source $HOME/.zshrc
    else
        echo "$HOME/.zshrc file not found. Unable to source."
    fi
fi

if [ $opencode ]; then
    echo "Installing OpenCode config..."
    
    # Ensure OpenCode config directory exists
    mkdir -p "$HOME/.config/opencode"
    
    # Symlink AGENTS.md file
    create_opencode_symlink "./opencode/AGENTS.md" "$HOME/.config/opencode/AGENTS.md"
    
    # Symlink subdirectories
    create_opencode_symlink "./opencode/agent" "$HOME/.config/opencode/agent"
    create_opencode_symlink "./opencode/command" "$HOME/.config/opencode/command"
    create_opencode_symlink "./opencode/skill" "$HOME/.config/opencode/skill"
    create_opencode_symlink "./opencode/tool" "$HOME/.config/opencode/tool"
    
    echo "OpenCode config installation complete."
fi

echo "Script execution completed."