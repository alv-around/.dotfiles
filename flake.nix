{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";
    nixgl.url = "github:nix-community/nixGL";
  };

  # use nix-command and flakes experimental features
  nixConfig = {
    extra-experimental-features = ["nix-command" "flakes"];
  };

  outputs = {
    nixpkgs,
    home-manager,
    nvf,
    nixgl,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    homeConfigurations = {
      inherit pkgs;
      # System is very important!
      extraSpecialArgs = {
        inherit nixgl;
      };
    };
  in {
    homeConfigurations = {
      # INFO: change key value to your username
      "alv" = home-manager.lib.homeManagerConfiguration (
        homeConfigurations
        // {
          modules = [
            nvf.homeManagerModules.default
            ./home/default.nix
          ];
        }
      );

      ## user of gh action
      "runner" = home-manager.lib.homeManagerConfiguration (
        homeConfigurations
        // {
          modules = [
            nvf.homeManagerModules.default
            ./tests/test_profile.nix
          ];
        }
      );
    };

    devShells.${system}.default = pkgs.mkShell {
      name = "home-manager-dev";
      packages = with pkgs; [
        home-manager.packages.${system}.default # Provides the 'home-manager' CLI tool from this flake
      ];
      shellHook = ''
        exec zsh
        echo "Welcome to the home-manager development shell!"
        echo "To apply your configuration, run: home-manager switch --flake ."
      '';
    };
  };
}
