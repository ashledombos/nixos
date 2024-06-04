{ config, pkgs, ... }:

let
  # Configuration du dépôt Git local
  #=====================================================================================
  gitRepo = "/etc/nixos/git/nixos";

  # Script de mise à jour Git avant chaque rebuild
  gitPull = pkgs.writeShellScript "git-pull.sh" ''
    cd "${gitRepo}"
    git fetch --dry-run 2>&1 | grep -q -v 'up to date' && git pull || echo "No changes to pull."
  '';
in
{
  # Paquets Système de Base
  #=====================================================================================
  environment.systemPackages = with pkgs; [
    git
    kdePackages.discover
    adi1090x-plymouth-themes
  ];

  # Configuration de l'Écran de Connexion SDDM
  #=====================================================================================
  services.displayManager.sddm.settings = {
    General = {
      GreeterEnvironment = "LANG=fr_FR.UTF-8"; # Langue du greeter
      Numlock = "on"; # Activation du pavé numérique
    };
  };

  # Support des Applications et Mises à Jour
  #=====================================================================================
  # Activation de fwupd pour la mise à jour du firmware
  services.fwupd.enable = true;
  
  # Support de Flatpak et PackageKit pour la gestion des applications
  services.flatpak.enable = true;
  services.packagekit.enable = true;
  
  # Portails supplémentaires pour le bureau KDE
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-kde ];

  # Gestion Automatique des Mises à Jour
  #=====================================================================================
  system.autoUpgrade = {
    enable = true;
    dates = "Sun *-*-* 21:30:00"; # Mise à jour automatique chaque dimanche à 21:30
  };

  systemd.timers.auto-upgrade.timerConfig.Persistent = true;

  # Maintenance Automatique de Nix Store
  #=====================================================================================
  systemd.services.nix-gc-optimize = {
    description = "Nix Garbage Collect and Store Optimization";
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = pkgs.writeScript "nix-maintenance" ''
      #!/bin/sh
      ${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 30d
      ${pkgs.nix}/bin/nix-store --optimize
    '';
    wantedBy = [ "multi-user.target" ];
  };

  systemd.timers.nix-gc-optimize = {
    description = "Weekly timer for Nix garbage collection and optimization";
    timerConfig = {
      OnCalendar = "Sun 21:30:00";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };

  # Configuration de Plymouth pour l'Écran de Démarrage
  #=====================================================================================
  boot.plymouth = {
    enable = true;
    theme = "rings";
    themePackages = with pkgs; [
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "rings" ];
      })
    ];
  };

  # Configuration Générale de Nix
  #=====================================================================================
  nix.extraOptions = ''
    keep-derivations = true
    keep-outputs = true
  '';
  system.extraDerivedProductHooks = [ gitPull ];
}
