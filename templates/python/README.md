# Python project template

## Develop

To start a shell with all dev dependencies:

```console
nix develop
```

### Build your own nix package

If some of the dependencies are not in nixpkgs (unprobable), build it yourself
by:

```console
nix shell github:nix-community/pip2nix
pip2nix generate --help
```
