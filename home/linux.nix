{
  config,
  pkgs,
  nixgl,
  ...
}: {
  age = {
    # Point to your unencrypted private key so agenix can decrypt at runtime
    identityPaths = ["${config.home.homeDirectory}/.ssh/id_agenix"];

    secrets = {
      "gemini-key".file = ./secrets/gemini-key.age;
      "claude-key".file = ./secrets/claude-key.age;
      "codex-key".file = ./secrets/codex-key.age;
    };
  };

  # Enable nixGL for graphics compatibility on generic Linux
  targets.genericLinux.nixGL = {
    packages = import nixgl {inherit pkgs;};
    defaultWrapper = "mesa";
  };

  #
  features = {
    ai = {
      enable = true;
      codecompanion = true;
    };
    k3s.enable = true;
    zellij.enable = false;
  };

  home = {
    username = "alv";
    homeDirectory = "/home/alv";

    packages = with pkgs; [
      wl-clipboard # Wayland clipboard

      ## Wezterm wrapped with nixgl for graphics compatibility.
      (config.lib.nixGL.wrap wezterm)
    ];
  };
}
