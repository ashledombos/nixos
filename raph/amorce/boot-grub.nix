# Démarrage avec GRUB pour les machines anciennes

{ pkgs, config, ... }:

{

  # Gestion du démarrage.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

}
