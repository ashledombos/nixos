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
  virtualisation.containers.shadow = {
    bindMounts."/dev" = {
      hostPath = "/dev";
      isReadOnly = false;
    };
    bindMounts."/sys" = {
      hostPath = "/sys";
      isReadOnly = false;
    };
    bindMounts."/proc" = {
      hostPath = "/proc";
      isReadOnly = false;
    };
    ephemeral = false;
    privateNetwork = false;
    autoStart = true;
  };

  systemd.services.setup-debian-container = {
    description = "Setup Debian Container";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${setupScript}/bin/setup-debian-container";
    };
  };
}
