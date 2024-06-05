# Fichier : boot-plymouth.nix

{ pkgs, config, lib, ... }:

let
  adi1090x-plymouth-themes = pkgs.adi1090x-plymouth-themes.override {
    selected_themes = [ "rings" ];
  };
in
{
  # Masquer les messages de démarrage et n'afficher que l'écran Plymouth
  boot.kernelParams = [ "quiet" "splash" ];

  # Désactiver l'éditeur de menu systemd-boot pour masquer le menu de sélection des générations
  boot.loader.systemd-boot.editor = false;

  # Activer Plymouth avec le thème "rings"
  boot.plymouth = {
    enable = true;
    theme = "rings";
    themePackages = [ adi1090x-plymouth-themes ];
  };
}
