{
  description = "Development dependencies managed by Home Manager";

  inputs = {
    # Nixpkgs: The primary source for all software packages.
    # You can change this to "nixos-unstable" for bleeding-edge packages,
    # but be aware of potential breakage.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Home Manager: The tool for managing user environments.
    # It should follow the same nixpkgs input to ensure compatibility.
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05"; # Match this with nixpkgs branch if possible
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      # Define the target system architecture.
      # For Arch Linux and Ubuntu, this is typically "x86_64-linux".
      system = "x86_64-linux";

      # Get the packages set for the defined system.
      pkgs = nixpkgs.legacyPackages.${system};

      # Determine the current user's username.
      # This makes the flake generic for any user running it.
      username = builtins.getEnv "USER";

    in {
      # Define a Home Manager configuration for the current user.
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs; # Pass the package set to Home Manager.

        # Import your Home Manager module (where your packages are listed).
        modules = [
          ./home/default.nix
        ];

        # Set the Home Manager state version.
        # This is crucial for avoiding unexpected breakage during Home Manager upgrades.
        # Set it to the release version of home-manager you are using, or a recent NixOS stable.
        home.stateVersion = "25.05"; # IMPORTANT: Update this if you change home-manager's release branch!
      };

      # (Optional) A development shell to easily run 'home-manager switch'.
      # You can enter this shell with 'nix develop'.
      devShells.${system}.default = pkgs.mkShell {
        name = "home-manager-dev";
        packages = with pkgs; [
          home-manager.packages.${system}.default # Provides the 'home-manager' CLI tool
          git # Useful if your flake is in a git repo
        ];
        shellHook = ''
          echo "Welcome to the home-manager development shell!"
          echo "To apply your configuration, run: home-manager switch --flake ."
        '';
      };
    };
}
