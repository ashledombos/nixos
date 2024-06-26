{ config, pkgs, ... }:

{
  imports = [
    ../config.nix
    ../services.nix
    ../boot-plymouth.nix
    ../portable.nix
    ../tailscale.nix
  ];

  # Paramètres du noyau nécessaires pour l'hibernation
  boot.kernelParams = [
    "resume=UUID=6fb7a131-779a-4c75-bb21-ac3970c74e9c"
    "resume_offset=27760640"
  ];

  # Utiliser les commandes suivantes pour obtenir ces informations:
  # UUID: findmnt -no UUID -T /var/lib/swapfile
  # Offset: sudo filefrag -e /var/lib/swapfile
}
