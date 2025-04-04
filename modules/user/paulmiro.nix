{ lib, pkgs, config, ... }:
with lib;
let cfg = config.simon.user.simon;
in
{

  options.simon.user.simon = { enable = mkEnableOption "activate user simon"; };

  config = mkIf cfg.enable {

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.simon = {
      isNormalUser = true;
      description = "simon";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = mkIf config.programs.zsh.enable pkgs.zsh;
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

    nix.settings = {
      allowed-users = [ "simon" ];
    };

  };
}
