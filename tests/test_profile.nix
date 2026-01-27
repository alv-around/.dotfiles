{lib, ...}: {
  # Import the default home configuration
  imports = [
    ../home/default.nix
  ];

  # Override specific fields for the 'runner' user
  home.username = lib.mkForce "runner";
  home.homeDirectory = lib.mkForce "/home/runner"; # Or whatever the home directory for the runner user should be
}
