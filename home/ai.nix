{
  pkgs,
  pkgs-unstable,
  config,
  lib,
  workmux,
  ...
}: let
  cfg = config.features.ai;
  ollamaHost = cfg.ollama.host;
  ollamaModel = cfg.ollama.model;
in {
  options.features.ai = {
    enable = lib.mkEnableOption "Option to enable ai";

    ollama = {
      local = lib.mkOption {
        type = lib.types.bool;
        default = false;
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

    # TODO: add codecompanion configuration
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
      home.packages = [
        pkgs-unstable.lima
        pkgs.pueue
        # INFO: skip running test when installing
        (workmux.packages.${pkgs.system}.default.overrideAttrs (oldAttrs: {
          doCheck = false;
        }))
      ];

      # INFO: mounttype `p9` and `virtiofsd` are at the time buggy
      home.file.".lima/_config/override.yaml".text = ''
        mountType: reverse-sshfs
      '';

      programs.zsh = {
        shellAliases = {
          gq = "pueue add -- gemini";
        };
        envExtra = ''
          export GEMINI_API_KEY="$(cat ${config.age.secrets.gemini-key.path})"
          export ANTHROPIC_API_KEY="$(cat ${config.age.secrets.claude-key.path})"
          export OPENAI_API_KEY="$(cat ${config.age.secrets.codex-key.path})"
        '';
      };

      # Workmux configuration for sandboxing
      # TODO: replace gemini for pi
      xdg.configFile."workmux/config.yaml" = {
        force = true;
        # INFO: Setting agent to `pi` creates an error.
        text = ''
          merge_strategy: rebase
          nerdfont: true
          agent: claude
          sandbox:
            enabled: true
            backend: lima
            toolchain: auto  # Automatically detects flake.nix
            env_passthrough:
              - GEMINI_API_KEY
              - ANTHROPIC_API_KEY
              - OPENAI_API_KEY
            lima:
              cpus: 2       # Optional: customize VM resources
              memory: 4GB
              disk: 50GB
        '';
      };

      services.pueue = {
        enable = true;
        settings = {
          daemon = {
            default_parallel_tasks = 2;
          };
        };
      };

      # TODO: remove code companion
      programs.nvf.settings.vim = {
        # Only installed if code-companion is enabled
        # TODO: make this also dependent on whether code-companion is enabled
        extraPackages = [pkgs-unstable.gemini-cli];
        # set 'GEMINI_API_KEY' here, so it can be use by gemini adapters
        # Otherwise would have to set manually `{gemini,gemini_cli}.env.GEMINI_API_KEY
        luaConfigPre = ''
          vim.env.GEMINI_API_KEY = vim.fn.system("cat " .. "${config.age.secrets.gemini-key.path}"):gsub("%s+", "")
        '';

        assistant.codecompanion-nvim = {
          enable = true;
          setupOpts = {
            # use the name of your adapter
            strategies = {
              chat = {adapter = "gemini_cli";};
              inline = {adapter = "gemini_cli";};
              agent = {adapter = "gemini_cli";};
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
                  gemini = function()
                    return require("codecompanion.adapters").extend("gemini", {
                      name = "api_gemini_cli",
                      defaults = {
                        auth_method = "gemini-api-key",
                      },
                    })
                  end,
                },
                acp = {
                  gemini_cli = function()
                    return require("codecompanion.adapters").extend("gemini_cli", {
                      defaults = {
                        auth_method = "gemini-api-key",
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
          {
            key = "<leader>ap";
            mode = "n";
            action = "<cmd>CodeCompanion<CR>";
            desc = "Open codecompaion prompt";
          }
          # TODO: this comand currently throws error. Research use case and application
          {
            key = "<leader>a!";
            mode = "n";
            action = "<cmd>CodeCompanionCmd<CR>";
            desc = "Execute codecompanion cmd";
          }
        ];
      };
    }
  ]);
}
