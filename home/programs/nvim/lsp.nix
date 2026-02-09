_input: {
  programs.nvf.settings.vim = {
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

      # additional
      typst.enable = true;
      bash.enable = true;
      helm.enable = true;
      json.enable = true;
      markdown.enable = true;
      yaml.enable = true;
    };
  };
}
