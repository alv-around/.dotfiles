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

  # NOTE: both command keys (⌘) now send control, and both option keys (⌥)
  # now send command — on both left and right sides. Same one-time enable
  # step as above: Karabiner-Elements > Settings > Complex Modifications >
  # "Add rule" > enable both "left_command -> left_control, left_option ->
  # left_command" and "right_command -> right_control, right_option ->
  # right_command" (grouped under "Move command to control, option to
  # command").
  xdg.configFile."karabiner/assets/complex_modifications/command_to_control_option_to_command.json".source =
    ./config/karabiner/command_to_control_option_to_command.json;
}
