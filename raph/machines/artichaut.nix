{ config, pkgs, ... }:

{
  imports = [
    ../config.nix
    ../services.nix
    ../boot-plymouth.nix
    ../tailscale.nix
    ../shadow.nix
    ../vscodium.nix
    # ../portable.nix
  ];

  # boot.loader.systemd-boot.enable = false;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.device = "nodev"; # Ou périph de démarrage

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Paquets 
  environment.systemPackages = with pkgs; [
    texliveFull
    jdk
  ];

}
