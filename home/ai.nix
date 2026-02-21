{
  pkgs,
  config,
  lib,
  ...
}: let
  ollamaHost = "127.0.01:11434";
  ollamaModel = "qwen2.5-coder:7b";
in {
  options.features.ai = {
    enable = lib.mkEnableOption "Option to enable ai";

    # TODO: evaluate aider-chat

    # TODO: add other adaptars like gemini and claude
    ollama = {
      local = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Whether to install ollama manually";
      };

      host = {
        type = lib.types.str;
        default = ollamaHost;
        example = ollamaHost;
        description = "Host of the ollama service";
      };

      model = {
        type = lib.types.str;
        default = ollamaModel;
        example = ollamaModel;
        description = "Model to install in ollama";
      };
    };
  };

  config = lib.mkIf config.features.ai.enable {
    # install ollama with GPU acceleration
    services.ollama = {
      enable = true;

      # Optional: Enable hardware acceleration.
      # Accepted values: "cuda" (Nvidia), "rocm" (AMD), or false (CPU only).
      # Note: If you are on an Apple Silicon Mac, you can leave this commented out;
      # Metal acceleration is built into the default macOS package.
      # INFO: amd setup: https://wiki.nixos.org/wiki/Ollama
      # TODO: put this config under a device flag
      acceleration = "rocm";

      # Optional: Configure environment variables for the service.
      environmentVariables = {
        OLLAMA_HOST = ollamaHost; # The default listening port
        # OLLAMA_ORIGINS = "http://localhost:8080"; # Uncomment if you plan to use a local WebUI
        # TODO: put this config under a device flag
        HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      };
    };

    # installed given model in ollama
    systemd.user.services.ollama-model-loader = {
      Unit = {
        Description = "Pull Ollama Models Declaratively";
        After = ["ollama.service"];
        Wants = ["ollama.service"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.ollama}/bin/ollama pull ${ollamaModel}";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };

    # Enable codecompanion with ollama adapter
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
                    url = "${ollamaHost}"
                  },
                  schema = {
                    model = {
                      default = "${ollamaModel}"
                    },
                  },
                })
              end,
            }
          '';
        };
      };
    };
  };
}
