{pkgs, ...}: {
  features = {
    ai = {
      enable = true;
      codecompanion = true;
    };
    k3s.enable = true;
    zellij.enable = false;
  };

  # TODO: update values
  home = {
    username = "alv";
    homeDirectory = "/Users/alv";

    packages = with pkgs; [
      wezterm
    ];
  };
}
