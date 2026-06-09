{
  description = "A modern JavaScript/TypeScript project template with React and Node.js";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    # Layout (inside the Lima sandbox configured in home/ai.nix):
    #   ┌──────────┬──────────┐
    #   │          │  codex   │   two agents, side by side
    #   │  claude  ├──────────┤
    #   │          │  pueue   │   task queue to orchestrate both
    #   └──────────┴──────────┘
    # `claude`/`codex` are workmux built-in agents: used as literal
    # commands they auto-receive prompt injection (no <agent> needed).
    workmux = {
      panes = [
        {
          command = "claude --dangerously-skip-permissions";
          focus = true;
        }
        {
          # vertical split = a divider running top-to-bottom -> right column
          command = "codex --yolo";
          split = "vertical";
        }
        {
          # horizontal split off codex -> bottom of the right column
          command = "pueued -d 2>/dev/null; pueue status; exec $SHELL";
          split = "horizontal";
          percentage = 40;
        }
      ];
    };

    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          nodejs_22
          pueue
        ];

        shellHook = ''
          echo "⚡ JavaScript/React/Node.js Dev Shell Active!"
          echo "Node version: $(node --version)"
          echo "NPM version:  $(npm --version)"
          echo "To get started, run 'npm install' and 'npm run dev' in the root directory."
        '';
      };
    });
  };
}
