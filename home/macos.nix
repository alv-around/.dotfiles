{pkgs, ...}: {
  features = {
    ai = {
      enable = true;
      codecompanion = true;
    };
    k3s.enable = true;
    zellij.enable = false;
  };

  home = {
    # TODO: fill this data
    username = "username";
    homeDirectory = "/home/username";

    packages = with pkgs; [
      wezterm
    ];
  };
}
