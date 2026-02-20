{lib, ...}: {
  programs.nvf.settings.vim = {
    # FIX: The next line should be removed. For more  context see:
    lazy.enable = false;

    assistant.codecompanion-nvim = {
      enable = true;
      setupOpts = {
        # Sets Claude as the default for chat, while Gemini is defined below
        # strategies.chat.adapter = "openrouter_claude";
        strategies = {
          chat = {adapter = "ollama";};
          inline = {adapter = "ollama";};
          agent = {adapter = "ollama";};
        };

        adapters = lib.generators.mkLuaInline ''
          {
            ollama = function()
              return require("codecompanion.adapters").extend("ollama", {
                env = {
                  url = "http://127.0..1:11434"
                },
                schema = {
                  model = {
                    default = "llama3.2:latest",
                  },
                },
              })
            end,
          }
        '';
      };
    };
  };
}
