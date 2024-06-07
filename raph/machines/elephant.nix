{ config, pkgs, ... }:

{
  imports = [
    ../config.nix
    ../services.nix
    ../boot-plymouth.nix
    ../portable.nix
  ];

  # Paramètres du noyau nécessaires pour l'hibernation
  boot.kernelParams = [
    "resume=UUID=<UUID du swap>"
    "resume_offset=<Offset du swap>"
  ];

  # Configuration spécifique à GRUB pour l'hibernation
  boot.loader.grub = {
    enable = true;
    version = 2;
    extraConfig = "resume=UUID=<UUID du swap> resume_offset=<Offset du swap>";
  };

  # Assurez-vous que ces valeurs sont correctement remplies avant de reconstruire
  # Utilisez les commandes suivantes pour obtenir ces informations:
  # UUID: findmnt -no UUID -T /home/swapfile
  # Offset: sudo filefrag -e /home/swapfile
}
