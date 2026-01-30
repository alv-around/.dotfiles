_inputs: {
  programs.nvf.settings.vim.binds.whichKey = {
    register = {
      "<leader>fg" = "Search Neogit";
      "<leader>g" = "Goto/Neogit";
      "<leader>o" = "Obsidian";
      "<leader>ol" = "Obsidian Links";
      "<leader>of" = "Obsidian Pickers";
    };
    setupOpts = {
      icons = {
        rules = [
          {
            pattern = "goto";
            icon = " ";
            color = "green";
          }
          {
            pattern = "neogit";
            icon = "󰊢 ";
            color = "orange";
          }
          {
            pattern = "obsidian";
            icon = "󰇈";
            # valid colors: azure, blue, cyan, green, grey, orange, purple, red, yellow
            color = "purple";
          }
        ];
      };
    };
  };
}
