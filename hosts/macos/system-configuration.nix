{
  mac_user,
  pkgs,
  ...
}: {
  # Primary user for user-scoped options (homebrew, system defaults, …)
  system.primaryUser = mac_user;

  # System-level account that home-manager attaches to; home-manager reads
  # `home.homeDirectory` from `config.users.users.<name>.home`.
  users.users.${mac_user} = {
    name = mac_user;
    home = "/Users/${mac_user}";
  };

  # Match the nix-command/flakes features enabled at the flake level.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  system = {
    # Automatically clear conflicting stock zshrc/bashrc files
    activationScripts.preActivation.text = ''
      echo "Cleaning up stock shell configuration files..."
      if [ -e /etc/bashrc ] && [ ! -L /etc/bashrc ]; then
        sudo mv /etc/bashrc /etc/bashrc.bak
      fi
      if [ -e /etc/zshrc ] && [ ! -L /etc/zshrc ]; then
        sudo mv /etc/zshrc /etc/zshrc.bak
      fi
    '';

    # Enable mapping and swap Caps Lock and Escape
    # FIX: this only loadas after inital run
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;

      # INFO: Remaps the ISO section/plus-minus (§/±) key to output standard backtick/tilde (`/~)
      nonUS.remapTilde = true;
    };

    defaults = {
      NSGlobalDomain = {
        # Disables the "press and hold" accent menu so keys repeat immediately instead
        ApplePressAndHoldEnabled = false;

        # Sets how long you must hold down a key before it starts repeating
        # Slider options map to: 120 (Long), 94, 68, 35, 25, 15 (Short)
        InitialKeyRepeat = 15;
        # Sets how quickly characters repeat once it starts
        KeyRepeat = 2;
      };
    };

    # Required by nix-darwin. Review the nix-darwin changelog before bumping.
    stateVersion = 6;
  };
}
