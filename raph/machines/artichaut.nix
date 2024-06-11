{ config, pkgs, ... }:

{
  imports = [
    ../config.nix
    ../services.nix
    ../boot-plymouth.nix
    # ../portable.nix
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2; 
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev"; # Ou périph de démarrage


  ];
}
