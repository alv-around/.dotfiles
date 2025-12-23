{
  config,
  pkgs,
  nixgl,
  ...
}: {
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

        git = {
          enable = true;
          gitsigns.enable = true;
        };

        diagnostics = {
          enable = true;
          config = {
            virtual_lines = false; # shows an extra line with the message
            virtual_text = true; # shows inline message
          };
        };

        lsp = {
          enable = true;
          # DISABLE LSP FORMATTING
          # We want Conform to handle the save, not the native LSP client.
          formatOnSave = true;
          inlayHints.enable = true;

          trouble = {
            enable = true;
            mappings = {
              workspaceDiagnostics = "<leader>xx";
              documentDiagnostics = "<leader>xd";
            };
          };
        };

        utility = {
          sleuth.enable = true;
          smart-splits.enable = true;
        };

        binds = {
          whichKey.enable = true;
        };

        tabline.nvimBufferline = {
          enable = true;
          # number options: “none”, “ordinal”, “buffer_id”, “both” or (luaInline)
          setupOpts.options.numbers = "none";
          mappings.closeCurrent = "<leader>bd";
        };

        # use mini.statusline which is compatible with tokyonight theme
        mini.statusline.enable = true;

        # neo-tree
        filetree = {
          neo-tree = {
            enable = true;
            setupOpts = {
              git_status_async = true;
              filesystem = {
                filtered_items = {
                  visible = true;
                };
              };
            };
          };
        };

        maps.normal = {
          "<leader>e".action = "<cmd>Neotree toggle<CR>";
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          # languages
          nix = {
            enable = true;
            format.type = ["alejandra"];
          };

          rust = {
            # handles the LSP setup internally.
            enable = true;
            extensions.crates-nvim.enable = true;
          };
        };
      };
    };
  };
}
