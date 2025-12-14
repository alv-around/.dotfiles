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
          formatOnSave = false;
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
            setupOpts.filesystem = {
              filtered_items = {
                visible = true;
              };
            };
          };
        };

        maps.normal = {
          "<leader>e".action = "<cmd>Neotree toggle<CR>";
          "<leader>f".action = ":lua require('conform').format()<CR>";
        };

        formatter.conform-nvim = {
          enable = true;
          setupOpts = {
            # This is the standard Conform setup to ensure it runs on save
            format_on_save = {
              timeout_ms = 500;
              lsp_fallback = true; # If no formatter is found, try LSP
            };
          };
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          # languages
          nix = {
            enable = true;
            format = {
              enable = true;
              type = "alejandra";
            };
            # extraDiagnostics.enable = true;
          };

          rust = {
            # handles the LSP setup internally.
            enable = true;

            # TODO: we want this but we don't want the lsp-error
            # Ensure crate-based LSP is handled via rustaceanvim
            # crates.enable = true;
          };
        };
      };
    };
  };
}
