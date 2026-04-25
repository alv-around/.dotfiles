_inputs: {
  imports = [
    ./autocomplete.nix
    ./git.nix
    ./keymaps.nix
    ./lsp.nix
  ];

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        vimAlias = true;

        clipboard = {
          enable = true;
          # Synchronize Neovim's unnamed register with the system clipboard (both + and *)
          registers = "unnamedplus";
        };

        theme = {
          enable = true;
          name = "tokyonight";
          style = "night";
        };

        diagnostics = {
          enable = true;
          config = {
            virtual_lines = false; # shows an extra line with the message
            virtual_text = true; # shows inline message
          };
        };

        utility = {
          sleuth.enable = true;
          smart-splits.enable = true;
          motion.flash-nvim.enable = true;
          snacks-nvim = {
            enable = true;
            setupOpts = {
              picker = {
                enable = true;
                sources = {
                  files = {
                    hidden = true; # Include .dotfiles
                    ignored = true; # Include files in .gitignore (crucial for some configs)
                    follow = true; # Follow symlinks
                  };
                  grep = {
                    hidden = true; # Include .dotfiles
                    follow = true; # Follow symlinks
                  };
                };
              };
            };
          };
        };

        mini = {
          ai.enable = true;
          icons.enable = true;
          surround.enable = true;
        };

        # TODO: add custom function to show file full-path on nvimTree buffer
        statusline.lualine.enable = true;

        tabline.nvimBufferline = {
          enable = true;
          # number options: “none”, “ordinal”, “buffer_id”, “both” or (luaInline)
          setupOpts.options.numbers = "none";
          mappings = {
            closeCurrent = "<leader>bd";
            cyclePrevious = "[b";
            cycleNext = "]b";
          };
        };

        # neo-tree
        filetree = {
          nvimTree = {
            enable = true;
            setupOpts = {
              diagnostics.enable = true;
              update_focused_file = {
                enable = true;
                update_root = true;
              };
            };
          };
        };

        # noice
        notify.nvim-notify.enable = true;
        ui.noice.enable = true;

        # aerial
        visuals.nvim-web-devicons.enable = true;
        utility.outline.aerial-nvim = {
          enable = true;
          mappings.toggle = "<leader>cs";
        };
      };
    };
  };
}
