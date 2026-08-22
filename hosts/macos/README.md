## Instructions to follow after a Darwin build

1. Logout, so the new keyboard layout can be loaded.
2. Login and change the keyboad to `us-altgr-int`
3. Open Karabiner-Elements, grant Input Monitoring / Accessibility when
   prompted, then Settings > Complex Modifications > "Add rule" > enable
   "Change caps_lock key" (installed by `home/macos.nix`). This enables
   Caps Lock: tap = Escape, hold = Control. Only needed once — the choice
   is stored in Karabiner's own `karabiner.json` and survives future rebuilds.
