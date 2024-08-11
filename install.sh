!#/bin/bash

# set -x

apt install stow zsh neovim fzf zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
rm ~/.zcompdump*; compinit

stow .

sudo usermod -s /usr/bin/zsh $(whoami)

echo 'ZSH shell was setup as default, restart your terminal and run: $ echo $SHELL'
