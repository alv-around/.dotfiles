# Shared "image" for the coding-agent microVM.
#
# This is a hypervisor-agnostic NixOS module describing the *contents* of the
# VM. The per-host bits that actually differ (hypervisor, cpu/mem, networking)
# are set where the VM is instantiated (see `mkAgentVm` in flake.nix), so the
# same image can be booted via qemu on NixOS and via vfkit on macOS.
{
  pkgs,
  lib,
  ...
}: {
  # claude-code / codex are unfree.
  nixpkgs.config.allowUnfree = true;

  networking.hostName = lib.mkDefault "agent-vm";

  # The coding agents + the task queue that orchestrates them, all inside the
  # sandbox so nothing touches the host.
  environment.systemPackages = with pkgs; [
    pueue
    claude-code
    gemini-cli
    codex
    pi-coding-agent

    # basic ergonomics for an interactive shell in the VM
    git
    coreutils
    bashInteractive
  ];

  # Unprivileged user the agents run as. Passwordless + console autologin so
  # `nix run .#agent-vm` drops you straight into a usable shell.
  users.users.agent = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    password = "";
  };
  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "agent";

  # Run the pueue daemon inside the VM so `pueue` works out of the box.
  systemd.services.pueued = {
    description = "pueue task queue daemon";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = "agent";
      ExecStart = "${pkgs.pueue}/bin/pueued -vv";
      Restart = "on-failure";
    };
  };

  # Behind user-mode NAT; no inbound exposure, keep it simple.
  networking.firewall.enable = lib.mkDefault false;

  system.stateVersion = "26.05";
}
