{ lib, pkgs, config, ... }:
with lib;
let cfg = config.simon.programs.ssh;
in
{
  options.simon.programs.ssh.enable = mkEnableOption "enable ssh";

  config = mkIf cfg.enable {

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "homeserver" = {
          hostname = "homeserver";
          user = "simon";
        };
      };
    };
  };
}
