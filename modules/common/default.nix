{ pkgs, lib, config, flake-self, ... }:
with lib;
let cfg = config.simon.common;
in
{

  options.simon.common = {
    enable = mkEnableOption "contains configuration that is common to all systems";
  };

  config = mkIf cfg.enable {

    programs.zsh.enable = true;

    simon = {
      locale.enable = true;
      nix-common.enable = true;
      openssh.enable = true;
      user = {
        simon.enable = true;
        root.enable = true;
      };
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      dnsutils
      git
      wget
    ];

    lollypops.extraTasks = {
      rebuild-nosecrets = {
        desc = "Rebuild without deloying secrets";
        cmds = [ ];
        deps = [
          "check-vars"
          "deploy-flake"
          "rebuild"
        ];
      };
    };

  };

}
