_inputs: {
  programs.nvf.settings.vim = {
    # TODO: research more whats possible with gitsigns
    git = {
      gitsigns.enable = true;

      neogit = {
        enable = true;
        # set the default mappings to null and define in keymaps so they are registered with which-key
        mappings = {
          open = null;
          commit = null;
          pull = null;
          push = null;
        };
      };
    };

    # TODO: research more what possible with diffview
    utility.diffview-nvim = {
      enable = true;
    };

    keymaps = [
      # neogit keymaps
      # TODO: learn more of neogit
      {
        key = "<leader>gg";
        mode = "n";
        action = "";
        desc = "Neogit";
      }
      {
        key = "<leader>ggs";
        mode = "n";
        action = "<cmd>Neogit<cr>";
        desc = "Status [Neogit]";
      }
      {
        key = "<leader>ggb";
        mode = "n";
        action = "<cmd>Neogit branch<cr>";
        desc = "Branch [Neogit]";
      }
      {
        key = "<leader>ggl";
        mode = "n";
        action = "<cmd>Neogit log<cr>";
        desc = "Log [Neogit]";
      }
      {
        key = "<leader>ggc";
        mode = "n";
        action = "<cmd>Neogit commit<cr>";
        desc = "Commit [Neogit]";
      }
      # search commands
      {
        key = "<leader>fgc";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.git_log() end";
        desc = "Search repo's commit history";
      }
      {
        key = "<leader>fgf";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.git_log_file() end";
        desc = "Search file's commit history";
      }
      {
        key = "<leader>fgb";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.git_branches() end";
        desc = "Search branches";
      }
    ];

    # Make the distinction clearer with which-key
    binds.whichKey = {
      register = {
        "<leader>gg" = "Neogit";
        "<leader>g" = "Goto";
      };
      setupOpts = {
        icons = {
          rules = [
            {
              pattern = "neogit";
              icon = "󰊢 ";
              color = "orange";
            }
            {
              pattern = "goto";
              icon = " ";
              color = "green";
            }
          ];
        };
      };
    };
  };
}
