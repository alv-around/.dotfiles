_inputs: {
  imports = [
    ./git.nix
    ./keymaps.nix
    ./lsp.nix
    ./notes.nix
  ];

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

        mini.icons.enable = true;

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

        # noice
        notify.nvim-notify.enable = true;
        ui.noice.enable = true;

        # aerial
        visuals.nvim-web-devicons.enable = true;
        utility.outline.aerial-nvim = {
          enable = true;
          mappings.toggle = "<leader>cs";
        };

        # blink-cmp
        autocomplete.blink-cmp = {
          enable = true;
          friendly-snippets.enable = true;
          mappings = {
            # complete = "<S-Tab>";
            confirm = "<S-Tab>";
            next = "<C-j>";
            previous = "<C-k>";
          };
        };
      };
    };
  };
}
