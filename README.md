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
nix run darwin-rebuild --extra-experimental-features "nix-command flakes" -- switch --flake .#YOUR_HOSTNAME  # first run
darwin-rebuild switch --flake .#<hostname> # afterwards
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

## Coding Agent MicroVM

A sandboxed [`microvm.nix`](https://github.com/microvm-nix/microvm.nix) VM that
bundles the coding agents (`claude-code`, `gemini-cli`, `codex`,
`pi-coding-agent`) and the `pueue` task queue, so the whole agentic workload
runs isolated from the host. The image is defined once in
[`hosts/common/agent-vm.nix`](./hosts/common/agent-vm.nix) and wired up in
[`flake.nix`](./flake.nix).

**Prerequisites**

- **NixOS:** works out of the box (KVM). The VM is a declarative systemd
  service on the `nixos-vm` host.
- **macOS:** Apple Silicon only. The Linux guest can't be built natively, so
  `nix.linux-builder` is enabled in
  [`hosts/macos/system-configuration.nix`](./hosts/macos/system-configuration.nix);
  the guest is then run via Apple Virtualization (`vfkit`).

### Ad-hoc run (macOS **and** Linux)

Boots an ephemeral VM in the foreground; nothing persists after it exits. On
macOS the first run builds the guest through the `linux-builder` (slow once,
cached afterwards).

```bash
nix run .#agent-vm      # start (Ctrl-a x in qemu, or close the window, to stop)
```

### Declarative, systemd-managed (NixOS)

On the `nixos-vm` host the VM is registered as `microvm@agent-vm` and its state
lives under `/var/lib/microvms/agent-vm`.

```bash
# start / stop
sudo systemctl start microvm@agent-vm
sudo systemctl stop  microvm@agent-vm

# status & logs
systemctl status microvm@agent-vm
journalctl -fu   microvm@agent-vm

# update after changing the image or flake, then restart it
sudo nixos-rebuild switch --flake .#<hostname>
sudo microvm -Ru agent-vm

# delete completely
sudo systemctl stop microvm@agent-vm
sudo rm -rf /var/lib/microvms/agent-vm
# (also remove `microvm.vms.agent-vm` from flake.nix if it should stay gone)
```

## Agentic Workflow

This setup supports a high-performance agentic workflow using several tools:

### Parallel Execution with `pueue`

[Pueue](https://github.com/Nukesor/pueue) is a task runner that allows you to
queue and manage long-running tasks in the background. It now runs **inside the
coding-agent microVM** (see above) rather than on the host — start the VM, open
a shell in it, and drive the agents from there. The `pueued` daemon is started
automatically inside the VM.

- **Queue a task:** `pueue add -- claude -p "Refactor the authentication module"`.
- **Check status:** Run `pueue status`.
- **View logs:** Run `pueue log <task_id>`.
- **Parallelism:** Tune with `pueue parallel <n>`.

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
