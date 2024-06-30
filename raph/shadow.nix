{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libva
    libva-utils
    libinput
    xorg.libXau
    xorg.libXdmcp
 #   libX11
    libvdpau-va-gl
    intel-media-driver
    vaapiIntel
    kwallet
  ];

  # Configuration des drivers OpenGL et VAAPI
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };
}
