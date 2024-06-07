# Fichier : boot-plymouth.nix

{ pkgs, config, ... }:

{
  # Masquer les messages de démarrage et n'afficher que l'écran Plymouth
  boot.kernelParams = [ "quiet" ];
  boot.loader.timeout = 0;
  # Désactiver l'éditeur de menu systemd-boot pour masquer le menu de sélection des générations
  # boot.loader.systemd-boot.editor = false;
  # boot.initrd.kernelModules = [ "intel_agp" ];
  # boot.kernelParams = [ "vga=795" "splash=verbose" ];

  # Activer Plymouth avec le thème "rings"
  #boot.plymouth = {
  #  enable = true;
  #  theme = "rings_2";
  #  themePackages = [ adi1090x-plymouth-themes ];
  #};
  boot.loader.grub = {
    enable = true;
    version = 2;
    #extraConfig = "resume=UUID=<UUID du swap> resume_offset=<Offset du swap>";
  };

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
