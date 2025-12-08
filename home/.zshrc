export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export PATH="$HOME/.nix-profile/bin:$PATH"
export EDITOR="nvim"

# starship terminal theme
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.config/zsh}/zinit"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

### History ###
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

### fzf ###
## Usage
# $ vim ../**<TAB> - Files under parent directory
# $ cd **<TAB> - Directories under current directory (single-selection)
# $ kill -9 **<TAB> - Fuzzy completion for PIDs is provided for kill command.

## Keybindings
# [CTR + r] - search history
# [CTR + t] - Fuzzy find all files and subdirectories of the working directory, and output the selection to STDOUT with preview for files and dirs
# [ALT + c] - Fuzzy find all subdirectories of the working directory, and run the command “cd” with the output as argument.
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
export FZF_CTRL_T_OPTS="--preview='bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || tree -C {}'"
source <(fzf --zsh) # allow for fzf history widget

## fzf-tab
# show hidden files
setopt GLOB_DOTS

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'tree -C $realpath'
zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'bat --style=numbers --color=always --line-range :500 $realpath 2>/dev/null || tree -C $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'bat --style=numbers --color=always --line-range :500 $realpath 2>/dev/null || tree -C $realpath'

### fzf + ripgrep ###
# ripgrep->fzf->vim [QUERY]
search() (
  RELOAD='reload:rg --column --color=always --smart-case {q} || :'
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            $EDITOR {1} +{2}     # No selection. Open the current line in Vim.
          else
            $EDITOR +cw -q {+f}  # Build quickfix list for the selected items.
          fi'
  fzf --disabled --ansi --multi \
      --bind "start:$RELOAD" --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
      --delimiter : \
      --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"
)

### Aliases ###
alias ls='ls -a --color'
alias vim='$EDITOR'

### keybindings ###
# [ ESC ] -> enter vicmd mode
# [ `a`/`i` ] in vicmd -> return to emacs mode
bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest
bindkey -M vicmd -r j # remove downhistory binding in vim mode
bindkey -M vicmd -r k # remove uphistory binding in vim mode

### Programming config ###
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ -f "${HOME}/.cargo/env" ]] then
    . "${HOME}/.cargo/env"
fi

if [[ -f "${HOME}/.zshrc.local" ]] then
    source "${HOME}/.zshrc.local"
fi

### evals hooks
eval "$(zoxide init --cmd cd zsh)"
eval "$(direnv hook zsh)"

