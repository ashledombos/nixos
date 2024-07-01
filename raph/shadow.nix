{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    docker-compose
    gnumake
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "raphael" ];

  systemd.services.xhost-local-root = {
    description = "Allow local root access to X server";
    after = [ "display-manager.service" ];
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.xorg.xhost}/bin/xhost +local:root";
      RemainAfterExit = true;
    };
  };
}
