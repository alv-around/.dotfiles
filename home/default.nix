{ config, pkgs, nixgl, ... }:

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
    stow       # Ensure stow is available for your workflow.
    tmux
    wezterm
    zoxide
    zsh
    gcc        # GNU Compiler Collection
    go         # Go programming language
    rustup     # Rust toolchain installer
    typescript
    ## Wezterm wrapped with nixgl for graphics compatibility.
    # (nixgl.wrapApplication wezterm)
  ];

  # You can optionally add other basic Home Manager settings here,
  # but per your request, we'll keep it minimal.
  # For example, to enable home-manager to manage itself:
  # programs.home-manager.enable = true;
  nixGL.packages = import <nixgl> { inherit pkgs; };
  nixGL.defaultWrapper = "mesa";

  programs = {
      home-manager.enable = true;
      wezterm.package = config.lib.nixGL.wrap pkgs.wezterm;
  };

  # Avoid displaying news on activation
  news.display = "silent";
  
}
