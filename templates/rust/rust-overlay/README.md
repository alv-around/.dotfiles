# Rust-Starter

A fully-featured template for rust projects with nix flakes

source: [|youtube| Vimjoyer - Effortless Rust Development with Nix](https://www.youtube.com/watch?v=Ss1IXtYnpsg&t=394s)

## Features

- [x] devshell
- [x] build package functionality
- [x] naersk for faster builds
- [x] rust-overlay to specify version and components in rust-toolchain
- [ ] gitlab build pipeline 

## Commands

### For development
- manually activate shell: `nix develop`
- run the usual cargo commands like: `cargo build/test/run`

### Packaging
- build: `nix build`
- run: `nix run`
