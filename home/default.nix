{ config, pkgs, ... }:

{
  # Define the packages you want available in your user environment.
  # These are the same packages you listed previously.
  home.username = "alv";
  home.homeDirectory = "/home/alv";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    fd
    fzf
    neovim
    starship
    stow      
    tmux
    # FIX: wezterm 
    zoxide
    zsh
    gcc        # GNU Compiler Collection
    go         # Go programming language
    rustup     # Rust toolchain installer
    typescript
  ];

  # You can optionally add other basic Home Manager settings here,
  programs.home-manager.enable = true;

  # Avoid displaying news on activation
  news.display = "silent";
}
