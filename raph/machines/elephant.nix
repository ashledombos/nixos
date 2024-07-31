{ config, pkgs, ... }:

{
  imports = [
    ../config.nix
    ../services.nix
    ../boot-plymouth.nix
    ../portable.nix
    ../paquets/tailscale.nix
  ];

  # Paramètres du noyau nécessaires pour l'hibernation
  boot.kernelParams = [
    "resume=UUID=c09eba78-6a7b-4f66-bbc4-0ba9b853bb51"
    "resume_offset=14956544"
  ];
#
#  # Configuration spécifique à GRUB pour l'hibernation
#  boot.loader.grub = {
#    enable = true;
#    version = 2;
#    extraConfig = "resume=UUID=<UUID du swap> resume_offset=<Offset du swap>";
#  };

  # Utiliser les commandes suivantes pour obtenir ces informations:
  # UUID: findmnt -no UUID -T /var/lib/swapfile
  # Offset: sudo filefrag -e /var/lib/swapfile
}
