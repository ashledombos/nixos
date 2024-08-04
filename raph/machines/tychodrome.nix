{ config, pkgs, ... }:

{
  imports = [
    ../commun.nix
    ../amorce/boot-grub.nix
    ../bureau/deepin.nix
    ../portable.nix
    ../paquets/netbird.nix
  ];

  # Configuration de la disposition du clavier par défaut
   services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  networking.hostName = "tychodrome"; # Definir le nom d’hôte.

  # Paquets 
  environment.systemPackages = with pkgs; [
  ];

}
