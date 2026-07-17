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
    username = "alvaround";
    homeDirectory = "/Users/alvaround";

    packages = with pkgs; [
      wezterm
    ];
  };
}
