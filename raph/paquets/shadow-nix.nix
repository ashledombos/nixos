{ config, pkgs, ... }:

{
  # Installer les paquets nécessaires pour ShadowPC
  environment.systemPackages = with pkgs; [
    libva-utils             # Pour le support de VAAPI
    vaapiVdpau              # Pour le support VDPau
    libvdpau-va-gl          # Pour l'accélération vidéo
    intel-media-driver      # Pilotes pour les médias Intel
    # gnome-keyring           # Pour la fonctionnalité "Remember Me"
    # Ajoutez d'autres paquets nécessaires ici si besoin
  ];

  hardware.opengl = {
    enable = true;  # Activer OpenGL
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl intel-media-driver ];
  };
}
