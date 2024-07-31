{ config, pkgs, ... }:


{
  # Paquets KDE Plasma
  environment.systemPackages = with pkgs; [
    kdePackages.discover
    skanlite
  ];

  security.pam.services.sddm.enableKwallet = true;
  security.pam.services.login.enableKwallet = true;

  xdg.portal.extraPortals = [
    pkgs.kdePackages.xdg-desktop-portal-kde
  ];
