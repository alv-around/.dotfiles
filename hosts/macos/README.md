## Instructions to follow after a Darwin build

1. Logout, so the new keyboard layout can be loaded.
2. Login and change the keyboad to `us-altgr-int`
3. Open Karabiner-Elements, grant Input Monitoring / Accessibility when
   prompted, then Settings > Complex Modifications > "Add rule" and enable
   all rules installed by `home/macos.nix`:
   - "Change caps_lock key" — Caps Lock: tap = Escape, hold = Control.
   - "left_command -> left_control, left_option -> left_command"
   - "right_command -> right_control, right_option -> right_command"
   (the last two are grouped under "Move command to control, option to
   command"). Only needed once — the choice is stored in Karabiner's own
   `karabiner.json` and survives future rebuilds.
