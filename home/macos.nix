{
  config,
  pkgs,
  ...
}: {
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
