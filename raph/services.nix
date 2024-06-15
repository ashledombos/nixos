{ config, pkgs, ... }:

{
  imports = [];

  # Mise à jour automatique du système
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "Mon *-*-* 03:00:00"; # Exécute les mises à jour chaque lundi à 3h00
    channel = "https://nixos.org/channels/nixos-24.05";
  };

  # Configuration du service de nettoyage et d'optimisation du store Nix
  systemd.services.nix-gc-optimize = {
    description = "Nettoyage du Garbage Collect Nix et optimisation du store";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeScript "nix-maintenance" ''
        #!/bin/sh
        ${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 30d
        ${pkgs.nix}/bin/nix-store --optimize
      '';
      User = "root";
      Group = "root";
    };
  };

  # Timer pour le nettoyage automatique
  systemd.timers.nix-gc-optimize = {
    description = "Timer hebdomadaire pour le nettoyage et l'optimisation du store Nix";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Mon *-*-* 04:00:00";  # Lancement chaque lundi après les mises à jour
      Persistent = true;  # S'exécute après un redémarrage si l'heure prévue est manquée
    };
  };

  # Configuration du service de mise à jour automatique du dépôt Git
  systemd.services.git-pull = {
    description = "Mise à jour automatique du dépôt Git";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeScript "git-pull" ''
        #!/bin/sh
        cd "/etc/nixos/git/nixos"
        ${pkgs.git}/bin/git fetch --dry-run 2>&1 | grep -q -v 'up to date' && ${pkgs.git}/bin/git pull || echo "Pas de changements à tirer."
      '';
      User = "root";
      Group = "root";
    };
  };

  # Timer pour la mise à jour quotidienne du dépôt Git
  systemd.timers.git-pull = {
    description = "Tirage quotidien du dépôt Git";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;  # S'exécute après un redémarrage si l'heure prévue est manquée
    };
  };
}
