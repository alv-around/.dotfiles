!#/bin/bash

# set -x

apt install stow zsh neovim

stow .

sudo usermod -s /usr/bin/zsh $(whoami)

echo 'ZSH shell was setup as default, restart your terminal and run: $ echo $SHELL'
