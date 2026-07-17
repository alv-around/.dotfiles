# TODO: add niri config to home-manager
# TODO: for a better way in install niri / noctalia
{pkgs, ...}: {
  programs.niri.enable = true;

  # Services noctalia's widgets talk to (network/power/battery). Not required
  # for niri itself to start, but the shell's applets stay empty without them.
  networking.networkmanager.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  services.displayManager.defaultSession = "niri";
  # Fonts for the shell UI and terminal.
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    inter
  ];

  # niri (Smithay/GLES) has no software-rendering fallback, so the default
  # build-vm std-VGA gives a black screen. Give the VM a GL-capable virtio GPU.
  # `vmVariant` => applies ONLY to `nixos-rebuild build-vm`, not a real install.
  # TODO: remove this when nixos is moved from VM
  virtualisation.vmVariant.virtualisation.qemu.options = [
    "-vga none"
    "-device virtio-vga-gl"
    "-display gtk,gl=on"
  ];
}
