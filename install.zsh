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

usage() {
    echo "Usage: $0 [-e your.name@example.com -n \"Your name\" -p path/to/.ssh/your.pub [-c youreditor]]"
}

while getopts ":e:n:p:c:h" o; do
    case "${o}" in
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

if [[ $email && $name && $path ]]; then
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

# Ensure config directory exists
mkdir -p $HOME/.config

# Backup existing .zshrc
if [ -f "$HOME/.zshrc" ]; then
    echo "Backing up $HOME/.zshrc"
    mv $HOME/.zshrc $HOME/.zshrc.bak
fi

# Copy the .zshrc file
if [ -f "./.zshrc" ]; then
    echo "Copying .zshrc to home directory..."
    cp ./.zshrc $HOME/.zshrc

    # Clone the Zsh plugins
    clone_repo "https://github.com/zsh-users/zsh-autosuggestions" "$HOME/.config/zsh/plugins/zsh-autosuggestions/"
    clone_repo "https://github.com/marlonrichert/zsh-autocomplete.git" "$HOME/.config/zsh/plugins/zsh-autocomplete/"
    clone_repo "https://github.com/zdharma-continuum/fast-syntax-highlighting" "$HOME/.config/zsh/plugins/fast-syntax-highlighting/"
else
    echo ".zshrc file not found in the current directory. Skipping copy."
fi

# Copy the starship.toml file
if [ -f "./starship.toml" ]; then
    echo "Copying starship.toml to $HOME/.config..."
    cp ./starship.toml $HOME/.config/starship.toml
else
    echo "starship.toml file not found in the current directory. Skipping copy."
fi

# Source the .zshrc file
if [ -f "$HOME/.zshrc" ]; then
    echo "Sourcing $HOME/.zshrc..."
    source $HOME/.zshrc
else
    echo "$HOME/.zshrc file not found. Unable to source."
fi

echo "Script execution completed."
