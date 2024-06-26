{ config, pkgs, ... }:



{
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    xorg.xhost
  ];

  services.docker.enable = true;
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
    heroic
    lutris
    protontricks
    protonup-qt
    wine-staging
    wineWowPackages.stagingFull
    winetricks
    xivlauncher
  ];

  # Configuration des drivers OpenGL et VAAPI
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
      intel-compute-runtime
      intel-ocl
      intel-vaapi-driver
      libva-utils
      vdpauinfo
    ];
  };

  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  services.kwalletd6 = {
    enable = true;
    settings = {
      Server = {
        socket = "/run/user/$UID/kwallet"; # Chemin où le socket sera créé
      };
    };
  };


}
