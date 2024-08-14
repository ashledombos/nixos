{ config, pkgs, ... }:

{

#  hardware.opengl = {
#    enable = true;
#    driSupport = true;
#  };

  boot.kernelModules = [ "uinput" ];

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="shadow-input"
  '';

  users.groups.shadow-input = {};

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    shadowcker
    git
    docker
    docker-compose
    gnumake
    xorg.xhost
  ];
  

}
