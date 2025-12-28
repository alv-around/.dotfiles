{
  config,
  pkgs,
  nixgl,
  ...
}: {
  # Adjust username and homeDirectory path to your local machine
  home = {
    username = "alv";
    homeDirectory = /home/alv;
    stateVersion = "25.05";
  };

  nixGL.packages = import nixgl {inherit pkgs;};
  nixGL.defaultWrapper = "mesa";

  fonts.fontconfig.enable = true;

  # Define the packages you want available in your user environment.
  home.packages = with pkgs; [
    # general
    bat
    fd
    fzf
    starship
    stow
    tmux
    tree
    wget
    zoxide
    zsh

    # clipboards
    wl-clipboard
    xclip

    # programming
    gcc # GNU Compiler Collection
    go # Go programming language
    rustup # Rust toolchain installer
    # rust-analyzer
    typescript
    lua

    ## Wezterm wrapped with nixgl for graphics compatibility.
    (config.lib.nixGL.wrap wezterm)
  ];

  xdg.configFile = {
    "nix/nix.conf".source = ./.config/nix/nix.conf;
    "starship/starship.toml".source = ./.config/starship/starship.toml;
    "tmux/tmux.conf".source = ./.config/tmux/tmux.conf;
    "wezterm".source = ./.config/wezterm;
  };

  # You can optionally add other basic Home Manager settings here,
  programs = {
    home-manager.enable = true;
    # direnv.enableZshIntegration is set to true as default
    direnv.enable = true;
    lazygit.enable = true;
  };

  # Avoid displaying news on activation
  news.display = "silent";
}
