## Requirements

- git
- [nix](https://nix.dev/install-nix#install-nix) & [nix's home manager](https://nix-community.github.io/home-manager/#sec-install-standalone)

## Installation

1. Adjust `username` to your settings in [`flake.nix`](./flake.nix#L37)

2. Run:

```
  home-manager switch --flake .
```
  > /!\ if you just freshly install nix and home-manager add the following flags: `--extra-experimental-features nix-command --extra-experimental-features flakes` 


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

## Development

To test your changes:

```
nix development
home-manager switch --flake .
exec zsh
```
