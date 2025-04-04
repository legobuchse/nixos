{ pkgs, lib, config, ... }:
with lib;
let cfg = config.simon.programs.direnv;
in
{

  options.simon.programs.direnv = {
    enable = mkEnableOption "activate direnv";
  };

  config = mkIf cfg.enable {

    programs = {
      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      git = { ignores = [ ".direnv/" ]; };
    };

  };

}
