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

        notes.todo-comments.enable = true;
        utility = {
          sleuth.enable = true;
          smart-splits.enable = true;
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
                  hide_dotfiles = false; # Don't treat dotfiles as hidden
                  hide_by_name = [
                    ".git" # You might still want to hide the .git folder itself
                  ];
                };
              };
            };
          };
        };

        maps.normal = {
          "<leader>e".action = "<cmd>Neotree toggle<CR>";
        };

        # Snacks picker keymaps. For more functionalities check:
        keymaps = [
          {
            key = "<leader><space>";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.smart() end";
            desc = "Find Files (Root Dir)";
          }
          {
            key = "<leader>/";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.grep() end";
            desc = "Grep (Root Dir)";
          }
          {
            key = "<leader>,";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.buffers() end";
            desc = "Buffers";
          }
          {
            key = "<leader>;";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.command_history() end";
            desc = "Command History";
          }
          # TODO: currently this is not returning any result
          {
            key = "<leader>n";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.notifications() end";
            desc = "Notification History";
          }
          # LSP
          {
            key = "<space>gd";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.lsp_definitions() end";
            desc = "Goto Definition";
          }
          {
            key = "<space>gD";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.lsp_declarations() end";
            desc = "Goto Declarations";
          }
          {
            key = "<space>gr";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.lsp_references() end";
            desc = "References";
          }
          {
            key = "<space>gI";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.lsp_implementations() end";
            desc = "Goto Implementations";
          }
          {
            key = "<space>gy";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.lsp_type_definitions() end";
            desc = "Goto T[y]pe Definition";
          }
          {
            key = "<space>ss";
            mode = "n";
            lua = true;
            action = "function() Snacks.picker.lsp_symbols() end";
            desc = "LSP Symbols";
          }
        ];

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

        notify.nvim-notify.enable = true;
        ui.noice.enable = true;
      };
    };
  };
}
