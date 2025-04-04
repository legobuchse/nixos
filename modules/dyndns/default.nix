{ lib, pkgs, config, self, ... }:
with lib;
let cfg = config.simon.dyndns;
in
{

  options.simon.dyndns = {
    enable = mkEnableOption "activate dyndns";
    domains = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "domains to update";
    };

    apiTokenFile = mkOption {
      type = types.str;
      default = "/run/keys/cloudflare-api-token";
      description = "path to the file containing the cloudflare api token";
    };
  };

  config = mkIf cfg.enable {
    services.cloudflare-dyndns = {
      enable = true;
      apiTokenFile = cfg.apiTokenFile;
      ipv4 = true;
      ipv6 = false;
      domains = cfg.domains;
    };

    lollypops.secrets.files."cloudflare-api-token" = {
      cmd = "echo \"CLOUDFLARE_API_TOKEN=$(rbw get cloudflare-api-token-edit-dns-all)\"";
      path = cfg.apiTokenFile;
    };
  };
}
