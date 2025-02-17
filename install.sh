#!/bin/bash

# interrupt if error
set -x

# install yay
sudo pacman -S --needed git base-devel stow
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# latop configuration
sudo pacman -S gnome-tweaks interception-caps2esc
sudo stow -t /etc etc
sudo systemctl enable --now udevmon.service

# console configuration
sudo pacman -S stow zsh neovim fzf zoxide tmux ripgrep fd zoxide ttf-jetbrains-mono-nerd starship
sudo yay -S wezterm-git

stow --ignore etc .

usermod -s /usr/bin/zsh $(whoami)

echo 'ZSH shell was setup as default, restart your terminal and run: $ echo $SHELL'
