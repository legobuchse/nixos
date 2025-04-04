# Using GeoIP with NGINX

## Prerequisites

1. Make sure simon.nginx.enableGeoIP is enabled.
2. Make sure, account ID and keyfile are set.

## Enable GeoIP for a virtual host

### When checking against a single group

Append the following to your virtual host configuration:

```nix
services.nginx.virtualHosts."${cfg.domain}".geo-ip = true;
```

or

```nix
services.nginx.virtualHosts."${cfg.domain}".locations."/".geo-ip = true;
```

### When checking against multiple criteria

```nix
services.nginx.virtualHosts."${cfg.domain}".extraConfig = toString (
  optional config.simon.nginx.enableGeoIP ''
    set $allowed 0;
    if ($allowed_country = yes) {
        set $allowed 1;
    }
    if ($allowed = 0) {
        return 403;
    }
  ''
);
```
