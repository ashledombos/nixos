{ config, pkgs, ... }:

{

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  boot.kernelModules = [ "uinput" ];

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="shadow-input"
  '';

  users.groups.shadow-input = {};

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    xorg.libX11
    xorg.libXau
    xorg.libXdmcp
    xorg.libxcb
    xorg.libXScrnSaver
    xorg.libXdamage
    xorg.libXrandr
    xorg.libXcomposite
    xorg.libXext
    xorg.libXfixes
    xorg.libXinerama
    xorg.libXi
    xorg.libXcursor
    xorg.libXtst
    libva
    libvdpau
    libglvnd
    libGL
    mesa
    gdk-pixbuf
    xwayland
    libpulseaudio
    alsa-lib
    curl
    dbus-glib
    libdbusmenu
    nspr
    nss
    libinput
    SDL2
    xdg-utils
    at-spi2-atk
    pango
    libbsd
    libxslt
  ];
  

}
