{
  config,
  pkgs,
  nixgl,
  ...
}: {
  home.username = "alv";
  home.homeDirectory = "/home/alv";

  age = {
    # Point to your unencrypted private key so agenix can decrypt at runtime
    identityPaths = ["${config.home.homeDirectory}/.ssh/id_agenix"];

    secrets = {
      "gemini-key" = {
        # The path to the encrypted file in your git repo
        file = ../home/secrets/gemini-key.age;
      };
    };
  };

  # Enable nixGL for graphics compatibility on generic Linux
  targets.genericLinux.nixGL = {
    packages = import nixgl {inherit pkgs;};
    defaultWrapper = "mesa";
  };

  home.packages = with pkgs; [
    wl-clipboard # Wayland clipboard
  ];
}
