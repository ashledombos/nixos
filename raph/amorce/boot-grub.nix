# Démarrage esthétique de l’ordinateur avec Plymouth (à améliorer)

{ pkgs, config, ... }:

{

  # Gestion du démarrage.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

}
