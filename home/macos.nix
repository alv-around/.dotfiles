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
    k3s.enable = true;
    zellij.enable = false;
  };

  home.packages = with pkgs; [
    wezterm
    dbeaver-bin # open-source, multi-database GUI client (pgAdmin doesn't build on darwin)
  ];

  # Podman on macOS runs containers inside a Linux VM ("podman machine") that
  # doesn't start on its own, so start it whenever we log in.
  launchd.agents.podman-machine-autostart = {
    enable = true;
    config = {
      ProgramArguments = ["${pkgs.podman}/bin/podman" "machine" "start"];
      RunAtLoad = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/podman-machine-autostart.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/podman-machine-autostart.log";
    };
  };
}
