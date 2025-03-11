## Requirements

- git
- ansible

Run:

```
ansible-playbook -i ansible/inventory.ini ansible/install_dependencies.yml -K
sudo pacman -Syu
```

if ansible dependencies are not installed, run:

```
ansible-galaxy install -r requirements.yml
```

## TODOs

- [x] zsh
- [x] fzf
- [x] tmux
- [x] keyboard conf (more or less)
- [x] add installation script for everything
