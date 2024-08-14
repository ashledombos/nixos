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
  

}
