{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
    libva
    libva-utils
    libinput
    xorg.libXau
    xorg.libXdmcp
  ];
}
