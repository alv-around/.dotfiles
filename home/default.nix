{
  config,
  pkgs,
  nixgl,
  ...
}: {
  # Adjust username and homeDirectory path to your local machine
  home.username = "alv";
  home.homeDirectory = /home/alv;
  home.stateVersion = "25.05";

  nixGL.packages = import nixgl {inherit pkgs;};
  nixGL.defaultWrapper = "mesa";

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
    # programming
    gcc # GNU Compiler Collection
    go # Go programming language
    rustup # Rust toolchain installer
    typescript

    ## Wezterm wrapped with nixgl for graphics compatibility.
    (config.lib.nixGL.wrap wezterm)
  ];

  # You can optionally add other basic Home Manager settings here,
  programs.home-manager.enable = true;

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        vimAlias = true;

        theme = {
          enable = true;
          name = "tokyonight";
          style = "night";
        };

        extraPlugins = with pkgs.vimPlugins; {
          neotree = {
            package = "neo-tree-nvim";
          };
        };

        filetree.neo-tree.enable = true;
        statusline.lualine.enable = true;

        # extraPlugins = {
        #   lualine-nvim = {};
        # };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          # languages
          nix.enable = true;
          rust.enable = true;
        };

        lsp = {
          enable = true;
          inlayHints.enable = true;
        };
      };
    };
  };

  # Avoid displaying news on activation
  news.display = "silent";
}
