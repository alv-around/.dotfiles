_inputs: {
  programs.nvf.settings.vim = {
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

    # Usage: check the repo's README: https://github.com/sindrets/diffview.nvim?tab=readme-ov-file#usage
    utility.diffview-nvim = {
      enable = true;
    };

    keymaps = [
      # neogit keymaps
      # TODO: learn more of neogit
      {
        key = "<leader>gs";
        mode = "n";
        action = "<cmd>Neogit<cr>";
        desc = "Status [Neogit]";
      }
      {
        key = "<leader>gb";
        mode = "n";
        action = "<cmd>Neogit branch<cr>";
        desc = "Branch [Neogit]";
      }
      {
        key = "<leader>gl";
        mode = "n";
        action = "<cmd>Neogit log<cr>";
        desc = "Log [Neogit]";
      }
      {
        key = "<leader>gc";
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
        desc = "Search commit history (repo)";
      }
      {
        key = "<leader>fgf";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.git_log_file() end";
        desc = "Search commit history (file)";
      }
      {
        key = "<leader>fgb";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.git_branches() end";
        desc = "Search branches";
      }
    ];
  };
}
