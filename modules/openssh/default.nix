{ lib, pkgs, config, ... }:
with lib;
let cfg = config.simon.openssh;
in
{

  options.simon.openssh = { enable = mkEnableOption "activate openssh"; };

  config = mkIf cfg.enable {

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

  };
}
