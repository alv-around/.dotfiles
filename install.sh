#!/bin/bash

# interrupt if error
set -x

# latop configuration
sudo stow -t /etc etc
sudo systemctl enable --now keyd.service

# console configuration
stow -t /home/alv --ignore etc .

usermod -s /usr/bin/zsh $(whoami)

echo 'ZSH shell was setup as default, restart your terminal and run: $ echo $SHELL'
