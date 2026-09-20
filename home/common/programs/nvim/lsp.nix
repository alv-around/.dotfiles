{
  pkgs,
  lib,
  ...
}: {
  programs.nvf.settings.vim = {
    treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      svelte
      typescript
      javascript
      css
      html
    ];

    # define folding
    options = {
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      foldlevel = 99; # start with everything open
      foldlevelstart = 99; # same, per-buffer
      foldenable = true;
    };

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
        enable = true;

        # rustaceanvim is a plain mkEnableOption with no default, so `enable`
        # above does not bring it in -- it has to be asked for. It vendors both
        # rust-analyzer and the codelldb adapter, hence the presets below going
        # off; nvf asserts if they stay on.
        lsp.enable = false;
        dap.debugger = [];

        extensions = {
          crates-nvim.enable = true;
          rustaceanvim = {
            enable = true;

            # nvf's default `server` also rebinds <leader>dc inside rust
            # buffers ("debuggables if no session, else continue"). Keep
            # <leader>dc as plain dap.continue and reach the picker through
            # <localleader>rd instead. Note `server` is a leaf option, so
            # setting it replaces the default wholesale and `cmd` has to be
            # repeated or rustaceanvim falls back to $PATH for rust-analyzer.
            setupOpts.server = {
              cmd = [(lib.getExe pkgs.rust-analyzer)];
              on_attach = lib.generators.mkLuaInline ''
                function(client, bufnr)
                  default_on_attach(client, bufnr)
                  local opts = {noremap = true, silent = true, buffer = bufnr}
                  vim.keymap.set("n", "<localleader>rd", ":RustLsp debuggables<CR>", opts)
                  vim.keymap.set("n", "<localleader>rr", ":RustLsp runnables<CR>", opts)
                  vim.keymap.set("n", "<localleader>rp", ":RustLsp parentModule<CR>", opts)
                  vim.keymap.set("n", "<localleader>rm", ":RustLsp expandMacro<CR>", opts)
                  vim.keymap.set("n", "<localleader>rc", ":RustLsp openCargo<CR>", opts)
                end
              '';
            };
          };
        };
      };

      python = {
        enable = true;
        format.type = ["ruff"];
      };

      typescript.enable = true;
      svelte = {
        enable = true;
        #FIXME: prettier crash in svelte (v0.9)
        format.type = ["biome"];
      };
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
