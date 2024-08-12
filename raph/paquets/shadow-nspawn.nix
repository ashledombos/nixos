{ config, pkgs, lib, ... }:

let
  # Ensure the URL and SHA256 are updated accordingly
  debianImage = pkgs.fetchurl {
    url = "https://cloud.debian.org/images/cloud/bookworm/20240717-1811/debian-12-generic-amd64-20240717-1811.tar.xz";
    sha256 = "b8111f62baffd1395c5b6640cd6fc2bbaa28f65e4c85f8741659002fdbe862f0";
  };

in {
  # Enable the systemd machine targets
  systemd.targets.machines.enable = true;

  # Define the nspawn container settings
  systemd.nspawn."debian-bookworm" = {
    enable = true;
    execConfig = { Boot = true; };
    filesConfig = { BindReadOnly = [ "/etc/resolv.conf:/etc/resolv.conf" ]; };
    networkConfig = { Private = false; };
  };

  # Define the service for starting the nspawn container
  systemd.services."systemd-nspawn@debian-bookworm" = {
    enable = true;
    requiredBy = [ "machines.target" ];
    overrideStrategy = "asDropin";
  };
}
