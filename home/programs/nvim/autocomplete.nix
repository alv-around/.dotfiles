{pkgs, ...}: {
  programs.nvf.settings.vim = {
    # Provide the dependency (MahanRahmati/blink-nerdfont.nvim)
    extraPlugins = {
      blink-nerdfont = {
        package = pkgs.vimPlugins.blink-nerdfont-nvim;
      };
      # TODO: add emoji comp with https://github.com/moyiz/blink-emoji.nvim
    };

    autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
      mappings = {
        # complete = "<S-Tab>";
        confirm = "<S-Tab>";
        next = "<C-j>";
        previous = "<C-k>";
      };
      setupOpts = {
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "nerdfont"
          ];
          providers = {
            nerdfont = {
              module = "blink-nerdfont";
              name = "Nerd Fonts";
              score_offset = 15;
              opts = {
                insert = true;
                trigger = ":-)"; # Your custom trigger!
              };
            };
          };
        };
      };
    };
  };
}
