{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    nvf.url = "github:notashelf/nvf";
    nixgl.url = "github:nix-community/nixGL";
    flake-utils.url = "github:numtide/flake-utils";
    workmux.url = "github:raine/workmux";
  };

  # use nix-command and flakes experimental features
  nixConfig = {
    extra-experimental-features = ["nix-command" "flakes"];
  };

  outputs = {
    nixpkgs,
    home-manager,
    agenix,
    nvf,
    nixgl,
    flake-utils,
    workmux,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = pkgs.mkShell {
        name = "home-manager-dev";
        packages = with pkgs; [
          home-manager.packages.${system}.default # Provides the 'home-manager' CLI tool from this flake
        ];
        shellHook = ''
          echo "Welcome to the home-manager development shell!"
          echo "To apply your configuration, run: home-manager switch --flake ."
        '';
      };
    })
    // {
      homeConfigurations = {
        # Configuration for your main Linux Wayland machine
        "alv" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {system = "x86_64-linux";};
          extraSpecialArgs = {
            inherit nixgl workmux;
          };
          modules = [
            agenix.homeManagerModules.default
            nvf.homeManagerModules.default
            ./home/default.nix
            ./hosts/alvpad.nix
          ];
        };

        ## user of gh action
        "runner" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {system = "x86_64-linux";};
          extraSpecialArgs = {
            inherit nixgl;
          };
          modules = [
            nvf.homeManagerModules.default
            ./tests/test_profile.nix
          ];
        };
      };
    };
}
