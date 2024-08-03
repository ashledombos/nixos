{ config, pkgs, ... }:

{
  # Installer les paquets nécessaires pour ShadowPC
  environment.systemPackages = with pkgs; [
    libva-utils             # Pour le support de VAAPI
    vaapiVdpau              # Pour le support VDPau
    libvdpau-va-gl          # Pour l'accélération vidéo
    intel-media-driver      # Pilotes pour les médias Intel
    libinput                # Pour la gestion des entrées
    libX11                  # Pour le support X11
    libXau                  # Pour libXau
    libXdmcp                # Pour libXdmcp
    libva                   # Pour VAAPI
    libva-glx               # Pour VAAPI avec GLX
    libva-x11               # Pour VAAPI avec X11
    libva-wayland           # Pour VAAPI avec Wayland (si nécessaire)
    libva-drm               # Pour VAAPI avec DRM
    gnome-keyring           # Pour la fonctionnalité "Remember Me"
    # Ajoutez d'autres paquets nécessaires ici si besoin
  ];

  hardware.opengl = {
    enable = true;  # Activer OpenGL
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl intel-media-driver ];
  };
}
