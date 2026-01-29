_inputs: {
  programs.nvf.settings.vim = {
    notes = {
      todo-comments.enable = true;

      # TODO: watch video to extend functionality: https://www.youtube.com/watch?v=5ht8NYkU9wQ
      obsidian = {
        enable = true;
        setupOpts = {
          workspaces = [
            {
              name = "personal";
              path = "~/Code/research_vault";
            }
          ];
          templates = {
            folder = "1.templates";
          };
        };
      };
    };

    # TODO: see docs for more interesting keymaps: https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#commands
    keymaps = [
      {
        key = "<leader>os";
        mode = "n";
        action = "<cmd>ObsidianSearch<cr>";
        desc = "Search Notes";
      }
    ];

    # TODO: move whichKey to its own file
    binds.whichKey = {
      register = {
        "<leader>o" = "Obsidian";
      };
    };
  };
}
