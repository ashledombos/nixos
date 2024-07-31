{ config, pkgs, ... }:

{
  # Paquets Système de Base
  environment.systemPackages = with pkgs; [
    git
    kdePackages.discover
    skanlite
    rustdesk-flutter
    vim
    inxi
    wget
  ];

  # Configuration de l'Écran de Connexion SDDM
  services.displayManager.sddm.settings = {
    General = {
      GreeterEnvironment = "LANG=fr_FR.UTF-8"; # Langue du greeter
      Numlock = "on"; # Activation du pavé numérique
    };
  };

  # activation de kde wallet
  security.pam.services.sddm.enableKwallet = true;
  security.pam.services.login.enableKwallet = true;

  # Support des Applications et Mises à Jour
  services.fwupd.enable = true;
  services.flatpak.enable = true;
  services.packagekit.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.kdePackages.xdg-desktop-portal-kde
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

# boot.cleanTmpFiles = true;

  # Configurer le pare-feu
  networking.firewall.enable = true;

# Prise en charge des programmes appimage

programs.appimage = {
  enable = true;
  binfmt = true;
};

}
