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

```bash
home-manager switch --flake .
```

### Updating Packages

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

### home-manager

```bash
home-manager switch --flake .
exec zsh
```

### Linux Machine

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
