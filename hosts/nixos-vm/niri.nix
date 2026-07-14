# TODO: add niri config to home-manager
{self, ...} @ inputs: {
  programs.niri.enable = true;
  programs.xwayland.enable = true;

  services.displayManager.defaultSession = "niri";
  services.xserver.enable = true;
}
