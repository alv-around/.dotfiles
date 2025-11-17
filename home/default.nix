{
  config,
  pkgs,
  nixgl,
  ...
}:

let
  # Pin LazyVim's Version
  lazyvim-pinned = pkgs.vimUtils.buildVimPlugin {
    pname = "LazyVim-2025-03-01";
    version = "2025-03-01";
    doCheck = false;
    src = pkgs.fetchFromGitHub {
      owner = "LazyVim";
      repo = "LazyVim";
      rev = "25abbf546d564dc484cf903804661ba12de45507";
      hash = "sha256-kgTdhFfqOK6HZrHF/LYge8cm20wuud7xlxBAUm0OL+M=";
    };
  };
in
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
    # programming
    gcc # GNU Compiler Collection
    go # Go programming language
    rustup # Rust toolchain installer
    # rust-analyzer
    typescript
    lua

    ## TODO: install waybar & wallust

    ## Wezterm wrapped with nixgl for graphics compatibility.
    (config.lib.nixGL.wrap wezterm)
  ];

  # You can optionally add other basic Home Manager settings here,
  programs.home-manager.enable = true;

  programs.lazygit.enable = true;

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      lazyvim-pinned
      # rustaceanvim
      # mason-lspconfig-nvim
    ];
    extraPackages = with pkgs; [
      luarocks
      lazygit
      nixfmt-rfc-style
      ripgrep
    ];
  };

  # Avoid displaying news on activation
  news.display = "silent";
}
