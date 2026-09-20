{
  config,
  pkgs,
  lib,
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

  # Workmux configuration for sandboxing
  # TODO: replace claude for pi
  # TODO: create a custom vm-image with nix
  # TODO: install in the custom image pueue
  xdg.configFile."workmux/config.yaml" = lib.mkIf config.features.ai.enable {
    force = true;
    # INFO: set agent to codex | claude | gemini | pi ..
    text = ''
      merge_strategy: rebase
      nerdfont: true
      agent: claude
      sandbox:
        enabled: true
        backend: lima
        toolchain: auto  # Automatically detects flake.nix
        env_passthrough:
          - GEMINI_API_KEY
          - ANTHROPIC_API_KEY
          - OPENAI_API_KEY
        lima:
          cpus: 2       # Optional: customize VM resources
          memory: 4GB
          disk: 50GB
    '';
  };
}
