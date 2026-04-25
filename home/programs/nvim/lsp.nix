{pkgs, ...}: {
  programs.nvf.settings.vim = {
    # TODO: update nixpkgs and remove this grammar
    treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      svelte
    ];

    lsp = {
      enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      presets = {
        tailwindcss-language-server.enable = true;
      };

      trouble = {
        enable = true;
        mappings = {
          workspaceDiagnostics = "<leader>xx";
          documentDiagnostics = "<leader>xd";
        };
      };
    };

    debugger.nvim-dap = {
      enable = true;
      ui.enable = true;
    };

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
      enableDAP = true;

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

      python = {
        enable = true;
        format.type = ["ruff"];
      };

      typescript.enable = true;
      svelte.enable = true;
      html.enable = true;

      clang.enable = true;
      cmake.enable = true;

      go.enable = true;

      # additional
      bash.enable = true;
      helm.enable = true;
      json.enable = true;
      yaml.enable = true;
    };
  };
}
