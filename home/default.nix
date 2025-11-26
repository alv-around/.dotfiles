{
  config,
  pkgs,
  nixgl,
  ...
}:
{
  # Adjust username and homeDirectory path to your local machine
  home.username = "alv";
  home.homeDirectory = /home/alv;
  home.stateVersion = "25.05";

  nixGL.packages = import nixgl { inherit pkgs; };
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
    wl-clipboard
    xclip
    # programming
    gcc # GNU Compiler Collection
    rustup # Rust toolchain installer
    lua
    go # Go programming language
    nodejs_22
    yarn-berry_4

    ## Wezterm wrapped with nixgl for graphics compatibility.
    (config.lib.nixGL.wrap wezterm)
  ];

  # You can optionally add other basic Home Manager settings here,
  programs.home-manager.enable = true;

  programs.lazygit.enable = true;

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter
    ];
    extraPackages = with pkgs; [
      luarocks
      lazygit
      ripgrep
    ];
  };

  # Avoid displaying news on activation
  news.display = "silent";
}
