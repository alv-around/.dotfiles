{mac_user, ...}: {
  # Primary user for user-scoped options (homebrew, system defaults, …)
  system.primaryUser = mac_user;

  # System-level account that home-manager attaches to; home-manager reads
  # `home.homeDirectory` from `config.users.users.<name>.home`.
  users.users.${mac_user} = {
    name = mac_user;
    home = "/Users/${mac_user}";
  };

  # Match the nix-command/flakes features enabled at the flake level.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # macOS can't build Linux natively, but the coding-agent microVM guest is a
  # Linux system. The linux-builder spins up a small aarch64-linux builder VM
  # so `nix run .#agent-vm` can build the guest before booting it via vfkit.
  nix.linux-builder.enable = true;
  # linux-builder requires the invoking user to be a trusted Nix user.
  nix.settings.trusted-users = ["@admin" mac_user];

  # Required by nix-darwin. Review the nix-darwin changelog before bumping.
  system.stateVersion = 6;
}
