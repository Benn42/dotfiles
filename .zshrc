HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"           # The path to the history file.
HISTSIZE=1000000000                  # The maximum number of events to save in the internal history.
SAVEHIST=1000000000                  # The maximum number of events to save in the history file.

setopt BANG_HIST                     # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY              # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY            # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY                 # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST        # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS              # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS          # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS             # Do not display a line previously found.
setopt HIST_IGNORE_SPACE             # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS             # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS            # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY                   # Do not execute immediately upon history expansion.
setopt glob_dots

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

unsetopt autocd beep notify

# Aliases
alias ls="ls --color=auto"

if [ -x "$(which exa)" ]; then
    alias ll='exa --long --all --group-directories-first'
fi

if [ -x "$(which nvim)" ]; then
    alias vim='nvim'
fi

# check bat command exists $(which bat)
if [ -x "$(which bat)" ]; then
  alias cat="bat "
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# auto suggestions
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
set ZSH_AUTOSUGGEST_USE_ASYNC=true
#fast syntax highlighting
source ~/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
#auto complete
source ~/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"      # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"      # This loads nvm bash_completion

eval "$(starship init zsh)"
