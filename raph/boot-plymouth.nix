# Fichier : boot-plymouth.nix

{ pkgs, config, ... }:

{
  # Masquer les messages de démarrage et n'afficher que l'écran Plymouth
  # boot.kernelParams = [ "quiet" ];

  # Désactiver l'éditeur de menu systemd-boot pour masquer le menu de sélection des générations
  boot.loader.systemd-boot.editor = false;

  # Activer Plymouth avec le thème "rings"
  #boot.plymouth = {
  #  enable = true;
  #  theme = "rings_2";
  #  themePackages = [ adi1090x-plymouth-themes ];
  #};
  boot.plymouth = {
    enable = true;
    # debug = true;
    theme = "spinfinity";
    # themePackages = with pkgs; [
    #  (adi1090x-plymouth-themes.override {
    #    selected_themes = [ "rings" ];
    #  })
    #];
  };
}
