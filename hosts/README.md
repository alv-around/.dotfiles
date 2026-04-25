# Hosts

This directory contains host-specific configuration files for Home Manager. This allows you to scale your setup easily as you add more computers.

## Adding a New Host

1. **Create a Configuration File:** Create a new `.nix` file in this directory (e.g., `macbook.nix`).
2. **Define Host Settings:** Specify your `home.username`, `home.homeDirectory`, and any device-specific packages or environment variables (such as display servers, graphic wrappers, etc.).

   ```nix
   # Example: hosts/macbook.nix
   { config, pkgs, ... }: {
     home.username = "alv";
     home.homeDirectory = "/Users/alv";
     
     home.packages = with pkgs; [
       # Add Mac-specific packages here
     ];
   }
   ```

3. **Register the Host:** Open `flake.nix` at the root of the repository and add a new entry to the `homeConfigurations` attribute using your new file. Make sure to define the correct system architecture (e.g., `aarch64-darwin` for Apple Silicon).

   ```nix
   "alv@macbook" = home-manager.lib.homeManagerConfiguration {
     pkgs = import nixpkgs { system = "aarch64-darwin"; };
     extraSpecialArgs = {
       inherit nixgl;
       pkgs-unstable = import nixpkgs-unstable { system = "aarch64-darwin"; };
     };
     modules = [
       agenix.homeManagerModules.default
       nvf.homeManagerModules.default
       ./home/default.nix
       ./hosts/macbook.nix
     ];
   };
   ```

4. **Apply Configuration:** Run the following command on your new machine to switch to its configuration:

   ```bash
   home-manager switch --flake .#alv@macbook
   ```