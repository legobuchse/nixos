{ lib, pkgs, config, ... }:
with lib;
let cfg = config.simon.docker;
in
{

  options.simon.docker = { enable = mkEnableOption "activate docker"; };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ docker-compose ];

    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    virtualisation.oci-containers = {
      backend = "docker";
    };

    users.extraGroups.docker.members = mkIf config.simon.user.simon.enable [ "simon" ];

  };
}