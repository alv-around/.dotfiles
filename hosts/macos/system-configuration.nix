{user, ...}: {
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

  # NOTE: Karabiner-Elements isn't buildable through nixpkgs on Darwin (it ships a
  # privileged virtual-HID system extension nix can't install/approve), so it
  # has to come from Homebrew, which nix-darwin drives declaratively here.
  #
  # Keyboard remaps  all live in the Karabiner-Elements
  # complex modification seeded by the `xdg.configFile` entry in
  # home/macos.nix.
  homebrew = {
    enable = true;
    # the default, spelled out for clarity) means this only
    # ensures the listed casks/brews are present — it never uninstalls
    # anything Homebrew-installed that isn't listed here,
    onActivation.cleanup = "none";
    casks = ["karabiner-elements"];
  };

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

      # Frees up Ctrl+Space / Ctrl+Option+Space, which macOS otherwise
      # intercepts system-wide for input source switching before they ever
      # reach an app — this is what breaks the WezTerm leader key (Ctrl+Space)
      # in wezterm/keys.lua. Takes effect after logout/restart.
      CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
        "60" = {enabled = false;}; # Select the previous input source
        "61" = {enabled = false;}; # Select next source in Input menu
      };
    };

    # Required by nix-darwin. Review the nix-darwin changelog before bumping.
    stateVersion = 6;
  };

  # Unlike Linux, which routes the whole 127.0.0.0/8 block to loopback by
  # default, macOS only owns 127.0.0.1 on lo0 — every other 127.x.x.x address
  # needs to be aliased onto lo0 explicitly before anything can bind/connect
  # to it. Aliasing the full /8 isn't practical (16M addresses), so alias
  # just the ones actually used; add more `ifconfig` lines here as needed.
  # Must be a system daemon (root, RunAtLoad) since interface aliases don't
  # persist across reboots and need to be back before services start.
  launchd.daemons.lo0-aliases = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        ''
          /sbin/ifconfig lo0 alias 127.22.0.1 netmask 255.0.0.0
          /sbin/ifconfig lo0 alias 127.24.0.1 netmask 255.0.0.0
        ''
      ];
      RunAtLoad = true;
    };
  };
}
