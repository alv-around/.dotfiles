_inputs: {
  programs.nvf.settings.vim.notes = {
    todo-comments.enable = true;

    neorg = {
      enable = true;
      treesitter.enable = true;
      setupOpts = {
        load = {
          "core.defaults".enable = true;
          "core.dirman" .config = {
            workspaces = {
              personal = "~/Code/vault_neorg";
            };
            default_workspace = "personal";
          };
        };
      };
    };
  };
}
