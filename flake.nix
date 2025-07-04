{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations = {
      "alv" = home-manager.lib.homeManagerConfiguration {
        # System is very important!
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        modules = [ ./home/default.nix ]; # Defined later
      };
    };
  };
}
