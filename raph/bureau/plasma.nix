{ config, pkgs, ... }:


{

  # Activation du bureau KDE Plasma 6.
  services.desktopManager.plasma6.enable = true;

  security.pam.services.sddm.enableKwallet = true;
  security.pam.services.login.enableKwallet = true;

  # Gestionnaire de connexion SDDM avec activation du pavé numérique
  services.displayManager.sddm = {
    enable = true;
    settings = {
      General = {
        GreeterEnvironment = "LANG=fr_FR.UTF-8";
        Numlock = "on";
      };
    };
  };

  # Activation de packageKit pour Discover
  services.packagekit.enable = true;

  # Portail GTK pour Firefox en mode Flatpak
  xdg.portal.extraPortals = [
    pkgs.kdePackages.xdg-desktop-portal-gtk
  ];

  # Paquets KDE Plasma (non disponibles dans Flathub)
  environment.systemPackages = with pkgs; [
    kdePackages.discover
    skanlite
  ];

}
