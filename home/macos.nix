{pkgs, ...}: {
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
}
