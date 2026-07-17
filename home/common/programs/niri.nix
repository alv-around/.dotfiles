# User-level niri + noctalia-shell desktop.
# Imported only by the nixos-vm host (see flake.nix). The compositor itself is
# enabled at the system level in hosts/nixos-vm/niri.nix.
{
  config,
  lib,
  pkgs,
  ...
}: {
  # Noctalia shell (bar/widgets). The homeModules.default from the flake input
  # supplies the package (built against noctalia's own nixpkgs-unstable).
  # settings default to noctalia's built-ins; add TOML here to customise:
  #   settings = { theme = { mode = "dark"; source = "builtin"; builtin = "Catppuccin"; }; };
  # See https://docs.noctalia.dev/v5
  programs.noctalia.enable = true;

  home.packages = with pkgs; [
    fuzzel # application launcher
    swaybg # wallpaper daemon
    firefox
    chromium
  ];

  # niri reads this at runtime; invalid config falls back to defaults + warns.
  # Reference: https://yalter.github.io/niri/
  # FIXME: noctalia is not being loaded
  # FIXME: wallpaper is not correctly being loaded
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
        touchpad {
            tap
            natural-scroll
        }
        focus-follows-mouse
    }

    layout {
        gaps 12
        center-focused-column "never"
        default-column-width { proportion 0.5; }

        focus-ring {
            width 3
            active-color "#7fc8ff"
            inactive-color "#3a3a3a"
        }
    }

    // Native-Wayland hints for the browsers.
    environment {
        MOZ_ENABLE_WAYLAND "1"
        NIXOS_OZONE_WL "1"
    }

    // Start the noctalia shell with the session.
    // Binary is `noctalia` (docs say `noctalia-shell`, but the package's
    // mainProgram is `noctalia`); getExe gives the absolute path.
    spawn-at-startup "${lib.getExe config.programs.noctalia.package}"

    // Wallpaper: add an image at ~/.config/niri/wallpaper.jpg and it appears
    // here on next login. Missing file => swaybg exits, niri backdrop shows.
    spawn-at-startup "swaybg" "-m" "fill" "-i" "${config.xdg.configHome}/niri/wallpaper.jpg"

    prefer-no-csd
    hotkey-overlay { }

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }

        // Launchers.
        Mod+Return { spawn "wezterm"; }
        Mod+T { spawn "wezterm"; }
        Mod+D { spawn "fuzzel"; }

        // Browsers.
        Mod+B { spawn "firefox"; }
        Mod+Shift+B { spawn "chromium"; }

        // Window management.
        Mod+Q { close-window; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }

        // Focus (vim keys + arrows).
        Mod+H     { focus-column-left; }
        Mod+L     { focus-column-right; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }

        // Move windows/columns.
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }

        // Workspaces.
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }

        // Column sizing.
        Mod+R { switch-preset-column-width; }
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        // Screenshots.
        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        // Session.
        Mod+Shift+E { quit; }
    }
  '';
}
