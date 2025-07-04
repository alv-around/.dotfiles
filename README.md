## Requirements

- git
- [wezterm](https://wezterm.org/install/linux.html#cachix)
- [nix](https://nix.dev/install-nix#install-nix) & [nix's home manager](https://nix-community.github.io/home-manager/#sec-install-standalone)

## Installation

1. Run:

```
  home-manager switch --flake .
```

After home-manager switch completes, it usually prompts you to restart your shell for changes to take full effect. And do this (e.g., `exec zsh` or `exec bash`).

finally Run:

```
  ./install.sh
```

### Updating Packages

```
rm flake.lock
nix flake update
home-manager switch --flake .
```

## Postinstallation

1. install rust-analyzer:

  ```
  rustup component add rust-analyzer
  ```
