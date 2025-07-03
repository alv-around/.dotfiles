# Setup fzf
# ---------
if [[ ! "$PATH" == */home/alv/.config/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/alv/.config/fzf/bin"
fi

source <(fzf --zsh)
