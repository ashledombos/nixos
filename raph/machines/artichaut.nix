{ config, pkgs, ... }:

{
  imports = [
    ../commun.nix
    ../amorce/boot-systemd.nix
    ../bureau/plasma.nix
    ../paquets/tailscale.nix
    ../paquets/shadow-nix.nix
    ../paquets/vscodium.nix
    # ../portable.nix
  ];

  # Configuration de la disposition du clavier par défaut
  services.xserver.xkb = {
    layout = "fr";
    variant = "bepo_afnor";
  };

  networking.hostName = "artichaut"; # Definir le nom d’hôte.

  # Paquets 
  environment.systemPackages = with pkgs; [
    texliveFull
    jdk
  ];

}
