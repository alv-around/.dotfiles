#!/bin/bash

set -x

sudo pacman -S stow zsh neovim fzf zoxide tmux ripgrep fd zoxide ttf-victor-mono-nerd

stow .

usermod -s /usr/bin/zsh $(whoami)

echo 'ZSH shell was setup as default, restart your terminal and run: $ echo $SHELL'
