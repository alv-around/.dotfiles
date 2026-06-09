{
  config,
  pkgs,
  nixgl,
  ...
}: {
  home = {
    username = "alv";
    homeDirectory = "/home/alv";

    packages = with pkgs; [
      wl-clipboard # Wayland clipboard
    ];
  };

  age = {
    # Point to your unencrypted private key so agenix can decrypt at runtime
    identityPaths = ["${config.home.homeDirectory}/.ssh/id_agenix"];

    secrets = {
      "gemini-key".file = ../home/secrets/gemini-key.age;
      "claude-key".file = ../home/secrets/claude-key.age;
      "codex-key".file = ../home/secrets/codex-key.age;
    };
  };

  # Enable nixGL for graphics compatibility on generic Linux
  targets.genericLinux.nixGL = {
    packages = import nixgl {inherit pkgs;};
    defaultWrapper = "mesa";
  };
}
