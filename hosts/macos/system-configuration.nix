{
  user,
  pkgs,
  ...
}: {
  # Primary user for user-scoped options (homebrew, system defaults, …)
  system.primaryUser = user;

  # System-level account that home-manager attaches to; home-manager reads
  # `home.homeDirectory` from `config.users.users.<name>.home`.
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
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

    # NOTE: Installs the "us-altgr-intl" keyboard layout, mirroring the Linux
    # "English (US, intl., with AltGr dead keys)" (altgr-intl) xkb variant:
    # Option+a = á, Option+q = ä, etc. macOS's built-in "U.S. International"
    # layout requires double-tapping dead keys instead, so it doesn't match.
    # Source: https://github.com/carjorvaz/macos-us-altgr-intl
    #
    # NOTE: nix-darwin can install the file, but macOS itself must be told to
    # enable it. After a rebuild (and a logout/restart if it doesn't show up
    # right away), add it manually: System Settings > Keyboard > Input
    # Sources > "+" > Others > "us-altgr-intl".
    activationScripts.postActivation.text = ''
      echo "Installing us-altgr-intl keyboard layout..."
      sudo mkdir -p "/Library/Keyboard Layouts"
      sudo cp ${./us-altgr-intl.keylayout} "/Library/Keyboard Layouts/us-altgr-intl.keylayout"
    '';

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

  # INFO: karabiner configuration is manage in user space
  environment.systemPackages = with pkgs; [
    karabiner-elements
  ];
}
