{ config, pkgs, ... }:

{
  imports = [
    ../config.nix
    ../services.nix
    ../boot-plymouth.nix
    ../paquets/tailscale.nix
    ../paquets/shadow.nix
    ../paquets/vscodium.nix
    # ../portable.nix
  ];

  ## Configuration de la disposition du clavier par défaut
  # services.xserver = {
  #  layout = "fr";
  #  xkbVariant = "bepo_afnor";
  #};

  # networking.hostName = "artichaut"; # Definir le nom d’hôte.

  # Paquets 
  environment.systemPackages = with pkgs; [
    texliveFull
    jdk
  ];

}
