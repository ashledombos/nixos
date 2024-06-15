# Fichier : boot-plymouth.nix

{ pkgs, config, ... }:

{
  # Masquer les messages de démarrage et n'afficher que l'écran Plymouth
  boot.kernelParams = [
    "quiet"
    "loglevel=0" # Réduire la verbosité des messages
    "vt.global_cursor_default=0" # Désactiver le curseur texte
    "nosgx"
  ];
  boot.loader.timeout = 0;
  # Désactiver l'éditeur de menu systemd-boot pour masquer le menu de sélection des générations
  # boot.loader.systemd-boot.editor = false;
  # boot.initrd.kernelModules = [ "intel_agp" ];
  # boot.kernelParams = [ "vga=795" "splash=verbose" ];
  boot.initrd.verbose = false;

  # Activer Plymouth avec le thème "rings"
  #boot.plymouth = {
  #  enable = true;
  #  theme = "rings_2";
  #  themePackages = [ adi1090x-plymouth-themes ];
  #};

  boot.initrd.systemd.enable = true;

  boot.plymouth = {
    enable = true;
    # debug = true;
    theme = "bgrt";
    # themePackages = with pkgs; [
    #  (adi1090x-plymouth-themes.override {
    #    selected_themes = [ "rings" ];
    #  })
    #];
  };
}
