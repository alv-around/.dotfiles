#!/bin/bash

# interrupt if error
set -x

# install rust-analyzer
rustup component add rust-analyzer

# latop configuration
sudo stow -t /etc etc
sudo systemctl enable --now udevmon.service

# console configuration
stow --ignore etc .

usermod -s /usr/bin/zsh $(whoami)

echo 'ZSH shell was setup as default, restart your terminal and run: $ echo $SHELL'
