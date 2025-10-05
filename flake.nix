{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add nixGL as an input
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixgl,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      homeConfigurations = {
        inherit pkgs;
        # System is very important!
        extraSpecialArgs = {
          nixgl = nixgl;
        };
      };
    in
    {
      homeConfigurations = {
        # INFO: change key value to your username
        "alv" = home-manager.lib.homeManagerConfiguration (
          homeConfigurations
          // {
            modules = [ ./home/default.nix ];
          }
        );

        ## user of gh action
        "runner" = home-manager.lib.homeManagerConfiguration (
          homeConfigurations
          // {
            modules = [ ./tests/test_profile.nix ];
          }
        );
      };

      devShells.${system}.default = pkgs.mkShell {
        name = "home-manager-dev";
        packages = with pkgs; [
          home-manager.packages.${system}.default # Provides the 'home-manager' CLI tool from this flake
          git # Useful if your flake is in a git repo
        ];
        shellHook = ''
          echo "Welcome to the home-manager development shell!"
          echo "To apply your configuration, run: home-manager switch --flake ."
        '';
      };
    };
}
