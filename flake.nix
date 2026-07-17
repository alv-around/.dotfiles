{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
    nvf.url = "github:notashelf/nvf";
    nixgl.url = "github:nix-community/nixGL";
    workmux.url = "github:raine/workmux";
    flake-utils.url = "github:numtide/flake-utils";

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    flake-utils,
    microvm,
    ...
  }: let
    linux_system = "x86_64-linux";
    linux_user = "alv";
    mac_system = "aarch64-darwin";
    # TODO: add your user and host-name
    mac_host = "Alvaros-iMac-Pro";
    mac_user = "alvaround";
    shared-inputs = [
      agenix.homeManagerModules.default
      nvf.homeManagerModules.default
      ./home/common/default.nix
    ];

    # Build the coding-agent microVM for a given system + hypervisor.
    # The image contents live in ./hosts/common/agent-vm.nix; only the
    # hypervisor-specific runtime bits differ between NixOS (qemu/KVM) and
    # macOS (vfkit / Apple Virtualization).
    mkAgentVm = {
      system,
      hypervisor,
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          microvm.nixosModules.microvm
          ./hosts/common/agent-vm.nix
          {
            microvm = {
              inherit hypervisor;
              vcpu = 2;
              mem = 4096;
              # User-mode networking: outbound internet for the agent APIs with
              # no host-side network setup. Works under both qemu and vfkit.
              interfaces = [
                {
                  type = "user";
                  id = "eth0";
                  mac = "02:00:00:01:01:01";
                }
              ];
            };
          }
        ];
      };
  in
    {
      # home-manager config
      homeConfigurations = {
        # Configuration for your main Linux Wayland machine
        ${linux_user} = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${linux_system};
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
        # The coding-agent microVM as a standalone NixOS system. Referenced by
        # the declarative host below, by the `microvm` command, and by
        # `nix run .#agent-vm` on Linux.
        agent-vm = mkAgentVm {
          system = linux_system;
          hypervisor = "qemu";
        };

        nixos-vm = nixpkgs.lib.nixosSystem {
          system = linux_system;
          modules = [
            ./hosts/nixos-vm/configuration.nix

            # microvm.nix host: manages declarative VMs as `microvm@<name>`
            # systemd services under /var/lib/microvms.
            microvm.nixosModules.host
            {
              microvm.vms.agent-vm = {
                flake = self;
                restartIfChanged = false;
              };
            }

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
                users.${linux_user} = {
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

      darwinConfigurations.${mac_host} = nix-darwin.lib.darwinSystem {
        system = mac_system; # Apple Silicon M1/M2/M3
        specialArgs = {inherit mac_user;};
        modules = [
          ./hosts/macos/system-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              sharedModules = [
                {
                  _module.args = {
                    inherit workmux;
                  };
                }
              ];
              users.${mac_user} = {
                imports = shared-inputs ++ [./home/macos.nix]; # Mix in Mac-specific user settings
              };
            };
          }
        ];
      };
    }
    # per-system outputs generated by flake-utils
    // flake-utils.lib.eachSystem [linux_system mac_system] (system: {
      devShells.default = nixpkgs.legacyPackages.${system}.mkShell {
        name = "home-manager-dev";
        shellHook = ''
          echo "Welcome to the home-manager development shell!"
          echo "To apply your configuration, run: home-manager switch --flake ."
        '';
      };

      # Runnable coding-agent microVM: `nix run .#agent-vm`.
      # On Linux this reuses the nixosConfiguration above (qemu/KVM); on macOS
      # it builds an aarch64-linux guest (via the nix-darwin linux-builder) and
      # runs it through vfkit / Apple Virtualization.
      packages.agent-vm =
        if system == linux_system
        then self.nixosConfigurations.agent-vm.config.microvm.declaredRunner
        else
          (mkAgentVm {
            system = "aarch64-linux";
            hypervisor = "vfkit";
          })
          .config
          .microvm
          .declaredRunner;

      checks =
        if system == linux_system
        then {
          hm-alv = self.homeConfigurations.${linux_user}.activationPackage;
          nixos-vm = self.nixosConfigurations."nixos-vm".config.system.build.toplevel;
          agent-vm = self.nixosConfigurations.agent-vm.config.microvm.declaredRunner;
        }
        else if system == mac_system
        then {
          darwin-system = self.darwinConfigurations.${mac_host}.system;
        }
        else {};
    });
}
