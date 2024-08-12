{ config, pkgs, ... }:

let
  debianImage = pkgs.fetchurl {
    url = "https://cloud.debian.org/images/cloud/bookworm/20240717-1811/debian-12-generic-amd64-20240717-1811.tar.xz";
    sha256 = "b8111f62baffd1395c5b6640cd6fc2bbaa28f65e4c85f8741659002fdbe862f0";
  };

  setupScript = pkgs.writeScriptBin "setup-debian-container" ''
    #!${pkgs.stdenv.shell}
    mkdir -p /var/lib/machines/debian-bookworm
    tar -xf ${debianImage} -C /var/lib/machines/debian-bookworm
  '';

in {
  systemd.targets.machines.enable = true;

  systemd.nspawn."debian-bookworm" = {
    enable = true;
    directory = "/var/lib/machines/debian-bookworm";  # Spécifier le chemin correct
    execConfig = { Boot = true; };
    filesConfig = { BindReadOnly = [ "/etc/resolv.conf:/etc/resolv.conf" ]; };
    networkConfig = { Private = false; };
  };

  systemd.services."systemd-nspawn@debian-bookworm" = {
    enable = true;
    requiredBy = [ "machines.target" ];
    overrideStrategy = "asDropin";
    serviceConfig = {
      ExecStartPre = "${setupScript}/bin/setup-debian-container"; # S’assurer que le script est exécuté avant le démarrage du service
    };
  };
}
