{pkgs, ...}: {
  features = {
    ai = {
      enable = true;
      codecompanion = true;
    };
    k3s.enable = true;
    zellij.enable = false;
  };

  home.packages = with pkgs; [wezterm];

  # NOTE: Caps Lock tap = Escape, Caps Lock held = Control. macOS's own
  # modifier-key remapping (System Settings > Keyboard > Modifier Keys, or
  # nix-darwin's `system.keyboard.remapCapsLockTo*`) can only apply a single
  # static remap and can't distinguish a tap from a hold, so this needs
  # Karabiner-Elements (installed in hosts/macos/system-configuration.nix).
  #
  # We only install the *asset* here, not karabiner.json itself: Karabiner
  # rewrites karabiner.json at runtime (e.g. when a rule is toggled), so a
  # nix-managed symlink there would fight the app. Dropping the rule into
  # assets/complex_modifications instead lets Karabiner's own picker see it.
  #
  # One-time manual step after a rebuild (mirrors the keyboard-layout step in
  # hosts/macos/README.md): open Karabiner-Elements, grant Input Monitoring /
  # Accessibility when prompted, then Settings > Complex Modifications >
  # "Add rule" > enable "Change caps_lock key". That choice is stored in
  # karabiner.json and survives future rebuilds without repeating this step.
  xdg.configFile."karabiner/assets/complex_modifications/caps_lock_control_escape.json".source =
    ./config/karabiner/caps_lock_control_escape.json;
}
