## Requirements

- git
- ansible
- rust:

  ```
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  ```

- rust-analyzer:

  ```
  rustup component add rust-analyzer
  ```

## Install

Run:

```
ansible-playbook -i ansible/inventory.ini ansible/install_dependencies.yml -K
sudo pacman -Syu
```

if ansible dependencies are not installed, run:

```
ansible-galaxy install -r requirements.yml
```

### Hyprland

install hyprland and [end-4](https://github.com/end-4/dots-hyprland?tab=readme-ov-file#-overview-) preconfiguration:

```
yay -Sy hyprland-meta-git
bash <(curl -s "https://end-4.github.io/dots-hyprland-wiki/setup.sh")
```

select `yesforall`
