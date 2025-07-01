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
