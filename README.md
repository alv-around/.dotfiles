# "Dotfiles"

## Requirements

- git
- [nix](https://nix.dev/install-nix#install-nix) &
  [nix's home manager](https://nix-community.github.io/home-manager/#sec-install-standalone)

## Installation

> /!\ if nix and home-manager are freshly installed either: add
> `experimental-features = nix-command flakes` to `~/.config/nix/nix.conf`, or
> flag to each nix command `--extra-experimental-features "nix-command flakes"`

1. Adjust `username` to your settings in [`flake.nix`](./flake.nix#L37)

2. Run:

```console
home-manager switch --flake .
```

### Updating Packages

```console
rm flake.lock
nix flake update
home-manager switch --flake .
```

## Development

To test your changes:

```console
nix development
home-manager switch --flake .
exec zsh
```
