{ lib, pkgs, config, ... }:
with lib;
let cfg = config.simon.programs.git;
in
{
  options.simon.programs.git.enable = mkEnableOption "enable git";

  config = mkIf cfg.enable {

    programs = {
      git = {
        enable = true;
        lfs.enable = true;
        ignores = [ ];
        extraConfig = {
          pull.rebase = true;
          init.defaultBranch = "main";
        };
        userEmail = "42503566+legobuchse@users.noreply.github.com";
        userName = "simon";
      };
    };
    home.packages = with pkgs; [
      pre-commit
    ];

  };
}
