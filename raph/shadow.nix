{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    docker-compose
    gnumake
    xorg.xhost
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "raphael" ];

  # Ajouter des services Docker et Docker Compose
  services.docker.enable = true;

}
