# Instructions to follow after a Darwin build

1. Logout, so the new keyboard layout can be loaded.
2. Login and change the keyboad to `us-altgr-int`
3. Karabiner-Elements one-time manual setup after installing (via the
   `homebrew.casks` entry above):
   1. Open Karabiner-Elements once. macOS will prompt to approve its background
      system extension (System Settings > Privacy & Security > allow, then
      possibly a restart) and grant it Input Monitoring access — this can't be
      done non-interactively.
   2. Go to the "Complex Modifications" tab > "Add rule" and enable all rules
      under "dotfiles keyboard remaps". This also can't be scripted: enabling a
      rule writes into ~/.config/karabiner/karabiner.json's active profile, a
      large GUI-managed file with per-device state that isn't safe to manage
      declaratively here.
   3. Check System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys is
      all defaults. Anything set there is the same kernel-level remap hidutil
      used, so it would rewrite Karabiner's output the same way and silently
      break these rules.
