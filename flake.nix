{
  description = "My NixOS infrastructure";

  inputs = {

    ### Essential inputs

    # Nix Packages collection & NixOS
    # https://github.com/nixos/nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # A collection of NixOS modules covering hardware quirks.
    # https://github.com/NixOS/nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Manage a user environment using Nix 
    # https://github.com/nix-community/home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Tools for managing NixOS infrastructure

    # NixOS Deployment Tool
    # https://github.com/pinpox/lollypops/
    lollypops = {
      url = "github:pinpox/lollypops";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, ... }@inputs:
    with inputs;
    let
      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ ]; });
    in
    {

      formatter = forAllSystems
        (system: nixpkgsFor.${system}.nixpkgs-fmt);

      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system}; in {

        });

      apps = forAllSystems (system: {
        lollypops = lollypops.apps.${system}.default { configFlake = self; };
      });

      # Output all modules in ./modules to flake. Modules should be in
      # individual subdirectories and contain a default.nix file
      nixosModules = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./modules + "/${x}");
        })
        (builtins.attrNames (builtins.readDir ./modules)));

      # Each subdirectory in ./machines is a host. Add them all to
      # nixosConfiguratons. Host configurations need a file called
      # configuration.nix that will be read first
      nixosConfigurations = builtins.listToAttrs (map
        (x: {
          name = x;
          value = nixpkgs.lib.nixosSystem {

            # Make inputs and the flake itself accessible as module parameters.
            # Technically, adding the inputs is redundant as they can be also
            # accessed with flake-self.inputs.X, but adding them individually
            # allows to only pass what is needed to each module.
            specialArgs = { flake-self = self; } // inputs;

            modules = [
              home-manager.nixosModules.home-manager
              lollypops.nixosModules.lollypops
              (import "${./.}/machines/${x}/configuration.nix" { inherit self; })
              { imports = builtins.attrValues self.nixosModules; }
            ];

          };
        })
        (builtins.attrNames (builtins.readDir ./machines)));

      homeConfigurations = {
        desktop = { pkgs, lib, username, ... }: {
          imports = [
            ./home-manager/profiles/common.nix
            ./home-manager/profiles/desktop.nix
          ] ++
          (builtins.attrValues self.homeManagerModules);
        };
        server = { pkgs, lib, username, ... }: {
          imports = [
            ./home-manager/profiles/common.nix
            ./home-manager/profiles/server.nix
          ] ++
          (builtins.attrValues self.homeManagerModules);
        };
      };

      homeManagerModules = builtins.listToAttrs (map
        (name: {
          inherit name;
          value = import (./home-manager/modules + "/${name}");
        })
        (builtins.attrNames (builtins.readDir ./home-manager/modules)));

    };
}
