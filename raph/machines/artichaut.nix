{ config, pkgs, ... }:

{
  imports = [
    ../config.nix
    ../services.nix
    ../boot-plymouth.nix
    ../tailscale.nix
    ../shadow.nix
    # ../portable.nix
  ];
  # boot.loader.systemd-boot.enable = false;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.device = "nodev"; # Ou périph de démarrage

  # Paquets 
  environment.systemPackages = with pkgs; [
    texliveFull
    jdk
  ];

}
