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
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-kde ];

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

# Configuration de Plymouth pour l'Écran de Démarrage
  # boot.plymouth = {
  # enable = true;
  #  theme = "rings";
  #  themePackages = with pkgs; [
  #    (adi1090x-plymouth-themes.override {
  #      selected_themes = [ "rings" ];
  #    })
  #  ];
  #};
}
