{
  config,
  pkgs,
  lib,
  ...
}: let
  codelldb = pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter;
in {
  features = {
    ai = {
      enable = true;
      codecompanion = true;
    };
    k3s.enable = false;
    zellij.enable = false;
  };

  home.packages = with pkgs; [
    wezterm
    dbeaver-bin # open-source, multi-database GUI client (pgAdmin doesn't build on darwin)

    azure-cli
  ];

  # Karabiner keymaps:
  # 1. Caps Lock = Escape tapped / left Control held,
  # 2. right Command <-> right Option
  xdg.configFile."karabiner/assets/complex_modifications/keyboard-remaps.json".source =
    ./config/karabiner/complex_modifications/keyboard-remaps.json;

  # silence .md errors
  programs.nvf.settings.vim.luaConfigPost =
    builtins.readFile ./config/nvim/marksman-ambiguous-link.lua;

  # nvf hardcodes `liblldb.so` in the codelldb adapter it hands rustaceanvim.
  # On darwin the library is `liblldb.dylib`, and codelldb panics rather than
  # ignoring a `--liblldb` path that doesn't exist, so point it at the real one.
  programs.nvf.settings.vim.languages.rust.extensions.rustaceanvim.setupOpts.dap.adapter = lib.generators.mkLuaInline ''
    {
      type = "server",
      port = "''${port}",
      executable = {
        command = "${codelldb}/bin/codelldb",
        args = {
          "--liblldb", "${codelldb}/share/lldb/lib/liblldb.dylib",
          "--port", "''${port}",
        },
      },
    }
  '';

  # Podman on macOS runs containers inside a Linux VM ("podman machine") that
  # doesn't start on its own, so start it whenever we log in.
  launchd.agents.podman-machine-autostart = {
    enable = true;
    config = {
      ProgramArguments = ["${pkgs.podman}/bin/podman" "machine" "start"];
      RunAtLoad = true;
      AbandonProcessGroup = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/podman-machine-autostart.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/podman-machine-autostart.log";
    };
  };
}
