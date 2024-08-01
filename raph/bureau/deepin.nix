{ config, pkgs, ... }:


{
  # Activation du bureau DDE de Deepin
  services.xserver.desktopManager.deepin.enable = true;

  # Gestionnaire de connexion SDDM avec activation du pavé numérique
  services.displayManager.sddm = {
    enable = true;
    theme = "Elegant";
    settings = {
      General = {
        GreeterEnvironment = "LANG=fr_FR.UTF-8";
        Numlock = "on";
      };
    };
  };

  # Paquets supplémentaires
  environment.systemPackages = with pkgs; [
      elegant-sddm
  ];

}
