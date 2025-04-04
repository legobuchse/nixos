{ pkgs, lib, config, flake-self, ... }:
with lib;
let cfg = config.simon.common-desktop;
in
{

  options.simon.common-desktop = {
    enable = mkEnableOption "contains configuration that is common to all systems with a desktop environment";
  };

  config = mkIf cfg.enable {

    simon = {
      common.enable = true;
      sound.enable = true;
      fonts.enable = true;
    };

    home-manager = {
      # DON'T set useGlobalPackages! It's not necessary in newer
      # home-manager versions and does not work with configs using
      # nixpkgs.config`
      useUserPackages = true;
      extraSpecialArgs = {
        # Pass all flake inputs to home-manager modules aswell so we can use them
        # there.
        inherit flake-self;
        # Pass system configuration (top-level "config") to home-manager modules,
        # so we can access it's values for conditional statements
        system-config = config;
      };
      users.simon = flake-self.homeConfigurations.desktop;
    };

  };

}
