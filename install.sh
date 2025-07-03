#!/bin/bash

# interrupt if error
set -x

# copy background pictures to pictures directory
cp .config/wezterm/backdrops/* ~/Pictures

# console configuration
stow -t ~ home

# latop configuration
sudo stow -t /etc etc
sudo systemctl enable --now keyd.service

usermod -s /usr/bin/zsh $(whoami)

echo 'ZSH shell was setup as default, restart your terminal and run: $ echo $SHELL'
