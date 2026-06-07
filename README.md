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

## Agentic Workflow

This setup supports a high-performance agentic workflow using several tools:

### Parallel Execution with `pueue`

[Pueue](https://github.com/Nukesor/pueue) is a task runner that allows you to queue and manage long-running tasks in the background.

- **Queue a task:** Use the `gq` alias (e.g., `gq "Refactor the authentication module"`).
- **Check status:** Run `pueue status`.
- **View logs:** Run `pueue log <task_id>`.
- **Parallelism:** By default, 2 tasks can run in parallel (configured in `home/ai.nix`).

### Agent Isolation with `workmux`

To prevent agents from messing with your active workspace, use `workmux`. It allows you to quickly spin up a git worktree in a separate directory/session. This is highly recommended when running parallel agents.

### Agent Interaction

For complex tasks, it is recommended to use the **Sub-Agent** architecture provided by Gemini CLI. Instead of manually piping agents, define specialized sub-agents (e.g., a "researcher", a "coder", a "tester") and have a coordinator agent delegate tasks to them. This ensures structured communication and better context management.
