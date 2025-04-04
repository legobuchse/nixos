{ pkgs, lib, config, ... }:
with lib;
let cfg = config.simon.grub;
in
{
  options.simon.grub = {
    enable = mkEnableOption "activate grub";
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          efiInstallAsRemovable = true;
          useOSProber = true;
          configurationLimit = 20;
        };
      };
      tmp.cleanOnBoot = true;
    };
  };
}
