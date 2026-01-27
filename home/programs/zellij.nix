{
  config,
  lib,
  ...
}: {
  options.features.zellij.enable = lib.mkEnableOption "Option to enable zellij";

  config = lib.mkIf config.features.zellij.enable {
    programs.zellij = {
      enable = true;
      # Optional: enable Zsh integration to auto-start or add completions
      enableZshIntegration = true;

      settings = {
        theme = "tokyo-night";

        copy_command = "xclip -selection clipboard";

        # Keybindings for horizontal/vertical splits, resizing, and tabs
        keybinds = {
          # These bindings work in "Normal" mode (no need to press Ctrl+g first)
          normal = {
            # Unbind the default 'Move' mode trigger
            "unbind \"Ctrl h\"" = {};

            # Pane management
            "bind \"Alt '\"" = {NewPane = "Right";}; # Vertical Split
            "bind \"Alt ;\"" = {NewPane = "Down";}; # Horizontal Split
            "bind \"Alt x\"" = {CloseFocus = [];}; # Close current pane/tab

            # Tab management
            "bind \"Alt t\"" = {NewTab = [];}; # New Tab
            "bind \"Alt w\"" = {CloseTab = [];}; # Close Tab (same as Alt+x usually)
            "bind \"Alt p\"" = {GoToNextTab = [];};
            "bind \"Alt n\"" = {GoToPreviousTab = [];};

            # Resizing
            "bind \"Alt ]\"" = {Resize = "Increase";};
            "bind \"Alt [\"" = {Resize = "Decrease";};

            # Navigation (Optional but helpful)
            "bind \"Alt h\"" = {MoveFocus = "Left";};
            "bind \"Alt l\"" = {MoveFocus = "Right";};
            "bind \"Alt j\"" = {MoveFocus = "Down";};
            "bind \"Alt k\"" = {MoveFocus = "Up";};
          };
        };

        # Minimal UI settings
        simplified_ui = true;
        pane_frames = false;
        default_layout = "compact";
      };
    };
  };
}
