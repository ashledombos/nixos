{ config, pkgs, ... }:

{
  imports = [
    ../commun.nix
    ../amorce/boot-systemd.nix
    ../bureau/plasma.nix
    ../paquets/netbird.nix
    ../paquets/vscodium.nix
    ../paquets/shadow-nspawn.nix
    ../portable.nix
  ];

  # Configuration de la disposition du clavier par défaut
  services.xserver.xkb = {
    layout = "fr";
    variant = "afnor";
  };

  networking.hostName = "etoile"; # Definir le nom d’hôte.

  # Paquets 
  environment.systemPackages = with pkgs; [
    veracrypt
    ecryptfs
  ];

 # Activer eCryptfs
  programs.ecryptfs.enable = true;

  # Activez le support eCryptfs pour PAM
  security.pam.enableEcryptfs = true;

}
