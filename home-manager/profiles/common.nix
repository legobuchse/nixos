{ config, pkgs, lib, flake-self, system-config, ... }:
with lib;
{
  config = {

    simon = {
      programs.direnv.enable = true;
      programs.git.enable = true;
      programs.ssh.enable = true;
      programs.zsh.enable = true;
      nixpkgs-config.enable = true;
    };

    # Home-manager nixpkgs config
    nixpkgs = {
      overlays = [ ];
    };

    # Include man-pages
    manual.manpages.enable = true;

    # Install these packages for my user
    home.packages = with pkgs; [
      asciinema
      croc
      dnsutils
      glances
      neofetch
      nil
      nix-tree
      nixpkgs-fmt
      openssl
      psmisc
      pwgen
      ripgrep
      sops
      tmux
      unzip
      usbutils
      zellij
    ];

    programs.yazi.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.stateVersion = "23.11";

  };
}
