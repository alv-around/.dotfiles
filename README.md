# "Dotfiles"

## Requirements

- git
- [nix](https://nix.dev/install-nix#install-nix) &
  [nix's home manager](https://nix-community.github.io/home-manager/#sec-install-standalone)

## Installation

> /!\ Make sure to have nix installed!

1. Adjust `username` to your settings in [`flake.nix`](./flake.nix#L37) and
   [`linux.nix](./home/linux.nix)/[`macos.nix`](./home/macos.nix)

2. If new computer make sure to create a new keys and re-encrypt the secrets

3. Run:

### Home Manager

```bash
nix run home-manager --extra-experimental-features "nix-command flakes" -- switch --flake (github:alv-around/.dotfiles).#YOUR_HOSTNAME  # first run
home-manager switch --flake . # afterwards
```

### System changes

#### NixOs

```bash
nix run nixos-rebuild --extra-experimental-features "nix-command flakes" -- switch --flake .#YOUR_HOSTNAME  # first run
nixos-rebuild switch --flake .#<hostname> # afterwards
```

#### MacOs

```bash
sudo nix run github:LnL7/darwin-rebuild --extra-experimental-features "nix-command flakes" -- switch --flake .  # first run
darwin-rebuild switch --flake . # afterwards
```

## Updating Packages

```bash
rm flake.lock
nix flake update (<input-name>)
home-manager switch --flake .
```

## Development

Start the devshell:

```bash
nix development
```

To test your changes:

```bash
nix flake check # for the current system
nix flake check --all-systems # for all systems
```

### Preview your changes

```bash
nix run nixpkgs#nixos-rebuild -- build-vm --flake .#nixos-vm
```

Once is finished building run:

```console
./result/bin/run-your-hostname-vm
```

> he first time you launch the script, it will create a virtual hard drive file
> (`.qcow2`) in your current working directory so the VM can persist files
> across reboots.

## Agentic Workflow

This setup supports a high-performance agentic workflow using several tools:

### Parallel Execution with `pueue`

[Pueue](https://github.com/Nukesor/pueue) is a task runner that allows you to
queue and manage long-running tasks in the background.

- **Queue a task:** Use the `gq` alias (e.g.,
  `gq "Refactor the authentication module"`).
- **Check status:** Run `pueue status`.
- **View logs:** Run `pueue log <task_id>`.
- **Parallelism:** By default, 2 tasks can run in parallel (configured in
  `home/ai.nix`).

### Agent Isolation with `workmux`

To prevent agents from messing with your active workspace, use `workmux`. It
allows you to quickly spin up a git worktree in a separate directory/session.
This is highly recommended when running parallel agents.

### Agent Interaction

For complex tasks, it is recommended to use the **Sub-Agent** architecture
provided by Gemini CLI. Instead of manually piping agents, define specialized
sub-agents (e.g., a "researcher", a "coder", a "tester") and have a coordinator
agent delegate tasks to them. This ensures structured communication and better
context management.
