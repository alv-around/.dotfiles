_inputs: {
  programs.nvf.settings.vim.notes = {
    todo-comments.enable = true;

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
}
