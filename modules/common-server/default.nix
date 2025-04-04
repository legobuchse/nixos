{ pkgs, lib, config, flake-self, ... }:
with lib;
let cfg = config.simon.common-server;
in
{

  options.simon.common-server = {
    enable = mkEnableOption "contains configuration that is common to all server machines";
  };

  config = mkIf cfg.enable {

    simon = {
      common.enable = true;
    };

    home-manager = {
      # DON'T set useGlobalPackages! It's not necessary in newer
      # home-manager versions and does not work with configs using
      # nixpkgs.config`
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs = {
        # Pass all flake inputs to home-manager modules aswell so we can use them
        # there.
        inherit flake-self;
        # Pass system configuration (top-level "config") to home-manager modules,
        # so we can access it's values for conditional statements
        system-config = config;
      };
      users.simon = flake-self.homeConfigurations.server;
    };

  };

}
