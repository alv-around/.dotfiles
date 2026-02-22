{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.features.ai;
  ollamaHost = cfg.ollama.host;
  ollamaModel = cfg.ollama.model;
  gemini_api_key = "AI...";
in {
  options.features.ai = {
    enable = lib.mkEnableOption "Option to enable ai";

    ollama = {
      local = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to install and run ollama service locally";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1:11434";
        description = "Host of the ollama service";
      };

      model = lib.mkOption {
        type = lib.types.str;
        default = "qwen2.5-coder:7b";
        description = "Model to install in ollama";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # --- CONDITION 1: Install Ollama locally ---
    (lib.mkIf cfg.ollama.local {
      services.ollama = {
        enable = true;
        acceleration = "rocm";
        environmentVariables = {
          OLLAMA_HOST = ollamaHost;
          HSA_OVERRIDE_GFX_VERSION = "11.0.0";
        };
      };

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
        Install.WantedBy = ["default.target"];
      };
    })

    # --- CONDITION 2: Always set up the adapter if AI is enabled ---
    {
      programs.nvf.settings.vim = {
        # BUG: this should be removed
        lazy.enable = false;

        assistant.codecompanion-nvim = {
          enable = true;
          setupOpts = {
            # use the name of your adapter
            strategies = {
              chat = {adapter = "api_gemini";};
              inline = {adapter = "api_gemini";};
              agent = {adapter = "api_gemini";};
            };

            adapters = lib.generators.mkLuaInline ''
              {
                http = {
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
                  api_gemini = function()
                    return require("codecompanion.adapters").extend("gemini", {
                      name = "api_gemini_cli",
                      defaults = {
                        auth_method = "gemini-api-key",
                      },
                      env = {
                        GEMINI_API_KEY = "${gemini_api_key}",
                      },
                    })
                  end,
                }
              }
            '';
          };
        };

        keymaps = [
          {
            key = "<leader>aa";
            mode = "n";
            action = "<cmd>CodeCompanionActions<CR>";
            desc = "Open codecompaion actions";
          }
          {
            key = "<leader>ac";
            mode = "n";
            action = "<cmd>CodeCompanionChat<CR>";
            desc = "Open ai chat";
          }
        ];
      };
    }
  ]);
}
