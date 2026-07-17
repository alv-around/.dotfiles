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

  # Required by nix-darwin. Review the nix-darwin changelog before bumping.
  system.stateVersion = 6;
}
