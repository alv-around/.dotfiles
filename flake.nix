{
    description = "My Home Manager Flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Add nixGL as an input
        nixgl.url = "github:nix-community/nixGL";
    };

    outputs = {nixpkgs, home-manager, nixgl, ...}: {
        homeConfigurations = {
            "alv" = home-manager.lib.homeManagerConfiguration {
                # System is very important!
                pkgs = import nixpkgs {
                    system = "x86_64-linux"; 
                    overlays = [nixgl.overlay];
                };

                modules = [
                    ./home/default.nix
                ]; 
            };
        };
    };
}
