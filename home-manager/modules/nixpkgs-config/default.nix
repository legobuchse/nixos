{ config, lib, ... }:
with lib;
{
  options = {
    simon.nixpkgs-config.enable = lib.mkEnableOption "nixpkgs config";
  };

  config = mkIf config.simon.nixpkgs-config.enable {
    nixpkgs.config = import ./nixpkgs-config.nix;
    xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;
  };
}
