{
  config,
  pkgs,
  ...
}: {
  home = {
    stateVersion = "25.11";
  };

  fonts.fontconfig.enable = true;

  # different modules with their flags
  imports = [
    ./ai.nix
    ./kube.nix
    ./notes.nix
    ./programs/nvim/default.nix
    ./programs/zellij.nix
  ];

  features = {
    ai.enable = true;
    k3s.enable = true;
    zellij.enable = false;
  };

  # Define the packages you want available in your user environment.
  home.packages = with pkgs; [
    # general
    fd
    ripgrep
    tree
    wget

    # dev
    nix-init

    ## Wezterm wrapped with nixgl for graphics compatibility (only on Linux).
    (
      if pkgs.stdenv.isLinux
      then (config.lib.nixGL.wrap wezterm)
      else wezterm
    )
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

    # adds syntax highlighting and aliases
    bat.enable = true;

    # auto-sources "zoxide init zsh"
    zoxide.enable = true;
    zoxide.enableZshIntegration = true;

    ### fzf ###
    ## Usage
    # $ vim ../**<TAB> - Files under parent directory
    # $ cd **<TAB> - Directories under current directory (single-selection)
    # $ kill -9 **<TAB> - Fuzzy completion for PIDs is provided for kill command.

    ## Keybindings
    # [CTR + r] - search history
    # [CTR + t] - Fuzzy find all files and subdirectories of the working directory, and output the selection to STDOUT with preview for files and dirs
    # [ALT + c] - Fuzzy find all subdirectories of the working directory, and run the command “cd” with the output as argument.
    fzf.enable = true;
    fzf.enableZshIntegration = true;

    starship = {
      enable = true;
      enableZshIntegration = true;
      # If you want to keep your starship.toml in the same place:
      settings = builtins.fromTOML (builtins.readFile ./config/starship/starship.toml);
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # Custom plugins (like fzf-tab)
      plugins = [
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
        # TODO: assess wheter to add zsh-vi-mode
        # see: https://github.com/jeffreytse/zsh-vi-mode?tab=readme-ov-file#execute-extra-commands
      ];

      # Snippets
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "command-not-found"
          "helm"
          "kubectl"
        ];
      };

      # Environment Variables
      sessionVariables = {
        EDITOR = "nvim";
        STARSHIP_CONFIG = "${config.xdg.configHome}/starship/starship.toml";
        FZF_ALT_C_OPTS = "--preview 'tree -C {}'";
        FZF_CTRL_T_OPTS = "--preview='bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || tree -C {}'";
      };

      shellAliases = {
        ls = "ls -a --color";
        vim = "nvim";
      };

      # History Settings
      history = {
        size = 5000;
        save = 5000;
        path = "${config.xdg.dataHome}/zsh/history";
        ignoreDups = true;
        share = true;
      };

      initContent = ''
        source ${./zshrc}
      '';
    };
  };

  # Avoid displaying news on activation
  news.display = "silent";
}
