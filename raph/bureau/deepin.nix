{ config, pkgs, ... }:


{

  # Activation du bureau KDE Plasma.
  services.displayManager.sddm.enable = true;
  services.desktopManager.deepin.enable = true;

  security.pam.services.sddm.enableKwallet = true;
  security.pam.services.login.enableKwallet = true;

  # Gestionnaire de connexion SDDM avec activation du pavé numérique
  services.displayManager.sddm.settings = {
    General = {
      GreeterEnvironment = "LANG=fr_FR.UTF-8"; # Langue du greeter
      Numlock = "on"; # Activation du pavé numérique
    };
  };

  xdg.portal.extraPortals = [
    pkgs.kdePackages.xdg-desktop-portal-kde
  ];

  # Paquets KDE Plasma
  environment.systemPackages = with pkgs; [
      elegant-sddm
  ];

}
