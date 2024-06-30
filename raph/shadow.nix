{ config, pkgs, ... }:

{
  hardware.opengl = {
    enable = true;
    driSupport = true;
  }

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "raphael" ];

}
