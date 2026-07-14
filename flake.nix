{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
    nvf.url = "github:notashelf/nvf";
    nixgl.url = "github:nix-community/nixGL";
    workmux.url = "github:raine/workmux";
  };

  # use nix-command and flakes experimental features
  nixConfig = {
    extra-experimental-features = ["nix-command" "flakes"];
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    agenix,
    nvf,
    nixgl,
    workmux,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    shared-inputs = [
      agenix.homeManagerModules.default
      nvf.homeManagerModules.default
      ./home/common/default.nix
    ];
  in {
    devShells.${system}.default = pkgs.mkShell {
      name = "home-manager-dev";
      shellHook = ''
        echo "Welcome to the home-manager development shell!"
        echo "To apply your configuration, run: home-manager switch --flake ."
      '';
    };

    # home-manager config
    homeConfigurations = {
      # Configuration for your main Linux Wayland machine
      "alv" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit nixgl workmux;
        };
        modules =
          shared-inputs
          ++ [
            ./home/linux.nix
          ];
      };
    };

    # NixOS config
    nixosConfigurations = {
      nixos-vm = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nixos-vm/configuration.nix

          # INFO: You can optionally import your HM right into the VM,
          # consider when proting to NixOs
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                {
                  _module.args = {
                    inherit nixgl workmux;
                  };
                }
              ];
              users.alv = {
                imports =
                  shared-inputs
                  ++ [
                    ./home/linux.nix
                  ];
              };
            };
          }
        ];
      };
    };

    darwinConfigurations."work-mac" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin"; # Apple Silicon M1/M2/M3
      modules = [
        ./hosts/macos/system-configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.sharedModules = shared-inputs;
          home-manager.users.alv = {
            imports = [./home/macos.nix]; # Mix in Mac-specific user settings
          };
        }
      ];
    };

    checks.${system} = {
      hm-alv = self.homeConfigurations."alv".activationPackage;
      nixos-vm = self.nixosConfigurations."nixos-vm".config.system.build.toplevel;
    };
  };
}
