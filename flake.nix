{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    nvf.url = "github:notashelf/nvf";
    nixgl.url = "github:nix-community/nixGL";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # use nix-command and flakes experimental features
  nixConfig = {
    extra-experimental-features = ["nix-command" "flakes"];
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    agenix,
    nvf,
    nixgl,
    flake-utils,
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
            inherit nixgl;
            pkgs-unstable = import nixpkgs-unstable {system = "x86_64-linux";};
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
            pkgs-unstable = import nixpkgs-unstable {system = "x86_64-linux";};
          };
          modules = [
            nvf.homeManagerModules.default
            ./tests/test_profile.nix
          ];
        };
      };
    };
}
