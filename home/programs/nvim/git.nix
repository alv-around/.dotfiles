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

    utility.diffview-nvim = {
      enable = true;
    };

    # TODO: set keymaps for gitsigns & diffview-nvim
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
    ];
  };
}
