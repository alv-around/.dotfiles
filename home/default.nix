{
  config,
  pkgs,
  nixgl,
  lib,
  ...
}: {
  # Adjust username and homeDirectory path to your local machine
  home = {
    username = "alv";
    homeDirectory = /home/alv;
    stateVersion = "25.05";
    sessionVariables = {
      # ENV_VARS
      NIXPKGS_ALLOW_UNFREE = 1; # Allow home-manager to use unfree apps, ex: obsidian
    };
  };

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "obsidian"
      ];
  };

  nixGL.packages = import nixgl {inherit pkgs;};
  nixGL.defaultWrapper = "mesa";

  fonts.fontconfig.enable = true;

  # different modules with their flags
  imports = [
    ./programs/nvim/default.nix
    ./programs/zellij.nix
  ];

  features.zellij.enable = false;

  # Define the packages you want available in your user environment.
  home.packages = with pkgs; [
    # general
    fd
    ripgrep
    tree
    wget

    # clipboards
    wl-clipboard

    # apps
    obsidian #TODO: find opensource replacement for obsidian

    ## Wezterm wrapped with nixgl for graphics compatibility.
    (config.lib.nixGL.wrap wezterm)
  ];

  xdg.configFile = {
    "wezterm".source = ./config/wezterm;
  };

  # You can optionally add other basic Home Manager settings here,
  programs = {
    home-manager.enable = true;

    # 1. Improved Tool Integrations
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    lazygit.enable = true;

    # Replaces pkgs.bat; adds syntax highlighting and aliases
    bat.enable = true;

    # Replaces pkgs.zoxide; auto-sources "zoxide init zsh"
    zoxide.enable = true;
    zoxide.enableZshIntegration = true;

    # Replaces pkgs.fzf; sets up keybinds (CTRL-T, etc.)
    fzf.enable = true;
    fzf.enableZshIntegration = true;

    starship = {
      enable = true;
      enableZshIntegration = true;
      # If you want to keep your starship.toml in the same place:
      settings = builtins.fromTOML (builtins.readFile ./config/starship/starship.toml);
    };

    # 2. Zsh Configuration
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # This is how you point to your existing .zshrc logic
      initContent = ''
        source ${./zshrc}
      '';
    };
  };

  # Avoid displaying news on activation
  news.display = "silent";
}
