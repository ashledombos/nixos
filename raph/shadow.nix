{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    xorg.xhost
  ];

  services.docker.enable = true;
}
