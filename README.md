## Requirements

- git
- [nix](https://nix.dev/install-nix#install-nix) & [nix's home manager](https://nix-community.github.io/home-manager/#sec-install-standalone)

## Installation

1. Adjust `username` to your settings in [`flake.nix`](./flake.nix#L37)

1. Add a new file called `home/local.nix` with the following content:

  ```nix
{
  username = "your-username";
  homeDirectory = "/path/to/home/dir";
}
  ```

3. Run:

```
  home-manager switch --flake .
```

  After home-manager switch completes, it usually prompts you to restart your shell for
  changes to take full effect. And do this (e.g., `exec zsh` or `exec bash`).

finally Run:

```
  ./install.sh
```

**For hyprland:** adjust `home/.config/wofi/style.css` to your user.

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
```
