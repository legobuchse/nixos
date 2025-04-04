{ lib, pkgs, config, ... }:
with lib;
let cfg = config.simon.nginx;
in
{

  options.simon.nginx = {
    enable = mkEnableOption "activate nginx";
    defaultDomain = mkOption {
      type = types.str;
      default = "teapot.example.com";
      description = "The default domain to use for the nginx configuration";
    };
  };

  config = mkIf cfg.enable {

    security.acme.defaults.email = "herreisen@gmx.de";
    security.acme.acceptTerms = true;

    services.nginx = {
      enable = true;
      clientMaxBodySize = "8196m"; # 8GiB
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      commonHttpConfig = ''
        map $scheme $hsts_header {
          https "max-age=31536000; includeSubdomains; -preload";
        }
        add_header Strict-Transport-Security $hsts_header;
      '';
      virtualHosts."${cfg.defaultDomain}" = {
        enableACME = true;
        forceSSL = true;
        default = true;
        locations."/" = {
          return = "418"; # I'm a teapot
        };
      };
    };
    systemd.services.nginx = mkIf config.simon.dyndns.enable {
      after = [
        "network.target"
        "cloudflare-dyndns.service"
      ];
      # Wait for 10 seconds to have the dns record up by the time the acme service runs
      serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
    };
    simon.dyndns.domains = [ cfg.defaultDomain ];
  };
}
