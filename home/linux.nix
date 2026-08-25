{
  config,
  pkgs,
  nixgl,
  ...
}: {
  # Enable nixGL for graphics compatibility on generic Linux
  targets.genericLinux.nixGL = {
    packages = import nixgl {inherit pkgs;};
    defaultWrapper = "mesa";
  };

  imports = [
    ./common/agenix.nix
    # TODO: try if DBeaver works well for linux
    ./common/programs/pgadmin.nix
  ];

  #
  features = {
    ai = {
      enable = true;
      codecompanion = true;
    };
    k3s.enable = true;
    zellij.enable = false;
  };

  home = {
    username = "alv";
    homeDirectory = "/home/alv";

    packages = with pkgs; [
      wl-clipboard # Wayland clipboard

      ## Wezterm wrapped with nixgl for graphics compatibility.
      (config.lib.nixGL.wrap wezterm)
    ];
  };
}
