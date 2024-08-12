{ config, pkgs, ... }:

let
  debianImage = pkgs.fetchurl {
    url = "https://cloud.debian.org/images/cloud/bookworm/20240717-1811/debian-12-generic-amd64-20240717-1811.tar.xz";
    sha256 = "b8111f62baffd1395c5b6640cd6fc2bbaa28f65e4c85f8741659002fdbe862f0";
  };

  setupScript = pkgs.writeScriptBin "setup-debian-container" ''
    #!${pkgs.stdenv.shell}
    mkdir -p /var/lib/machines/shadow
    tar -xf ${debianImage} -C /var/lib/machines/shadow
  '';

in {
  systemd.nspawn.machines.shadow = {
    enable = true;
    directory = "/var/lib/machines/shadow";
    ephemeral = false;
    privateUsers = false;
    bind = {
      "/dev" = "/dev";
      "/sys" = "/sys";
      "/proc" = "/proc";
    };
    execConfig = {
      ExecStartPre = "${setupScript}/bin/setup-debian-container";
    };
  };
}
