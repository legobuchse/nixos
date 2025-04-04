{ lib, pkgs, config, ... }:
with lib;
let cfg = config.simon.user.root;
in
{

  options.simon.user.root = {
    enable = mkEnableOption "activate user root";
  };

  config = mkIf cfg.enable {

    users.users.root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINU3dGzlm/LoTZpAvzlhge/96wuw3lb3DZppkMZ7SEM/ herre@SchwarzerKasten"
      ];
      /*
      openssh.authorizedKeys.keyFiles = [
        (pkgs.fetchurl {
          url = "https://github.com/legobuchse.keys";
          hash = "sha256-sPd2cSzVgsgd2bNbXb9kgeCnlp3GsnPQfRseLdQImtU=";
        })
      ];
      */
    };

  };
}
