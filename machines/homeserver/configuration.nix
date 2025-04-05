{ self, ... }:
{ config, pkgs, lib, ... }:

{
  simon = {

    common-server.enable = true;
    systemd-boot.enable = true;

    #nginx.enable = true;
    #nginx.enableGeoIP = true;

    # Exposed Services
    librespeedtest = {
      #enable = true;
      #enableNginx = true;
    };


  };

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # enable all the firmware with a license allowing redistribution
  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "homeserver";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    tempAddresses = "disabled";
  };

  # Configure console keymap
  console.keyMap = "de";

  # being able to build aarm64 stuff
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
