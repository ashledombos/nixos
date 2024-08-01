{ config, pkgs, ... }:

{
  imports = [
    ../commun.nix
    ../bureau/deepin.nix
    ../paquets/shadow.nix
    #../paquets/vscodium.nix
    ../portable.nix
  ];

  # Configuration de la disposition du clavier par défaut
   services.xserver = {
    layout = "fr";
    xkbVariant = "afnor";
  };

  networking.hostName = "girofle"; # Definir le nom d’hôte.

  # Paquets 
  environment.systemPackages = with pkgs; [
  ];

}
