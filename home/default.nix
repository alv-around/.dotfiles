{
  config,
  pkgs,
  nixgl,
  ...
}:

{
  # Define the packages you want available in your user environment.
  # These are the same packages you listed previously.
  home.username = "alv";
  home.homeDirectory = "/home/alv";
  home.stateVersion = "25.05";

  nixGL.packages = import nixgl { inherit pkgs; };
  nixGL.defaultWrapper = "mesa";
  nixGL.installScripts = [ "mesa" ];

  home.packages = with pkgs; [
    fd
    fzf
    neovim
    starship
    stow
    tmux
    zoxide
    zsh
    nixfmt-rfc-style
    gcc # GNU Compiler Collection
    go # Go programming language
    rustup # Rust toolchain installer
    typescript

    ## Wezterm wrapped with nixgl for graphics compatibility.
    (config.lib.nixGL.wrap wezterm)
  ];

  # You can optionally add other basic Home Manager settings here,
  programs.home-manager.enable = true;

  # Avoid displaying news on activation
  news.display = "silent";
}
