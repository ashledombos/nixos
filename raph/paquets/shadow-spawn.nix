{ config, pkgs, lib, ... }:

let
  debianImage = pkgs.fetchurl {
    url = "https://cloud.debian.org/images/cloud/bookworm/20240717-1811/debian-12-generic-amd64-20240717-1811.tar.xz";
    hash = "sha512-1e668159c0041896cd241b4280765b03eee6957308948daf942a95801bdcbcd937bf0be60f7cae3d4b8db02d4a3b1a04fa2eb0411e0defe4b5f14cb48f19ba98";
  };

  setupScript = pkgs.writeScript "setup-debian-container.sh" ''
    #!${pkgs.stdenv.shell}
    mkdir -p /var/lib/machines/shadow
    tar -xf ${debianImage} -C /var/lib/machines/shadow
  '';

in {
  systemd.services.setup-debian-container = {
    description = "Setup Debian Container";
    wantedBy = [ "multi-user.target" ];
    script = setupScript;
    serviceConfig.Type = "oneshot";
  };

  systemd.nspawn.containers.shadow = {
    enable = true;
    ephemeral = false;
    directory = "/var/lib/machines/shadow";
    privateUsers = false;
    bind = {
      "/dev" = "/dev";
      "/sys" = "/sys";
      "/proc" = "/proc";
    };
  };
}
