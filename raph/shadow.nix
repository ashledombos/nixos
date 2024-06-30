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
}
