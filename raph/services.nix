{ config, pkgs, ... }:

{
# mise à jour
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "03:00:00"; // Pour la mise à jour et le redémarrage
    #fixedRandomDelay = true;
    #operation = "boot";
  };

# Active le nettoyage automatique du store Nix
  systemd.services.nix-gc-optimize = {
    description = "Nix Garbage Collect and Store Optimization";
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

  systemd.timers.nix-gc-optimize = {
    description = "Weekly timer for Nix garbage collection and optimization";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun 21:30:00";
      Persistent = true;
    };
  };

  systemd.services.git-pull = {
    description = "Git repository auto-update";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeScript "git-pull" ''
        #!/bin/sh
        #export PATH=${pkgs.git}/bin:$PATH
        cd "/etc/nixos/git/nixos"
        ${pkgs.git}/bin/git fetch --dry-run 2>&1 | grep -q -v 'up to date' && ${pkgs.git}/bin/git pull || echo "No changes to pull."
      '';
      User = "root";
      Group = "root";
    };
  };

  systemd.timers.git-pull = {
    description = "Periodically pull git repository";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };
}
#  systemd.services.nix-gc-optimize = {
#    description = "Nix Garbage Collect and Store Optimization";
#    serviceConfig = {
#      Type = "oneshot";
#      ExecStart = "${pkgs.writeScriptBin "nix-maintenance" ''
#        #!/bin/sh
#        ${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 30d
#        ${pkgs.nix}/bin/nix-store --optimize
#      ''}";
#      User = "root";
#      Group = "root";
#    };
#    wantedBy = [ "multi-user.target" ];
#  };
#
#  systemd.timers.nix-gc-optimize = {
#    description = "Weekly timer for Nix garbage collection and optimization";
##    timerConfig = {
#      OnCalendar = "Sun 21:30:00";
#      Persistent = true;
#    };
#    wantedBy = [ "timers.target" ];
#  };
