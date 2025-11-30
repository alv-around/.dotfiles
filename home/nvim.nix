{
  config, pkgs, nixgl, ...
}:{
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

        utility = {
          sleuth.enable = true;
          smart-splits.enable = true;
        };

        binds = {
          whichKey.enable = true;
        };

        # use mini.statusline which is compatible with tokyonight theme
        mini.statusline.enable = true;

        # neo-tree
        filetree = {
          neo-tree = {
            enable = true;
            setupOpts.filesystem = {
              filtered_items = {
                visible = true;
              };
            };
          };
        };

        maps.normal = 
          {
            "<leader>e".action = "<cmd>Neotree toggle<CR>";
          };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          # languages
          nix = {
            enable = true;
            extraDiagnostics.enable = true;
            format = {
              enable = true;
              type = "nixfmt";
            };
          };
          rust.enable = true;
        };

        lsp = {
          # Warning: uncommenting next line create error msg
          # enable = true;
          inlayHints.enable = true;
        };
      };
    };
  };
}
