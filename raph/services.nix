{ config, pkgs, ... }:

{
  systemd.services.nix-gc-optimize = {
    description = "Nix Garbage Collect and Store Optimization";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeScriptBin "nix-maintenance" ''
        #!/bin/sh
        ${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 30d
        ${pkgs.nix}/bin/nix-store --optimize
      ''}";
      User = "root";
      Group = "root";
    };
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

  systemd.services.git-pull = {
    description = "Git repository auto-update";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeScriptBin "git-pull" ''
        #!/bin/sh
        cd "/etc/nixos/git/nixos"
        git fetch --dry-run 2>&1 | grep -q -v 'up to date' && git pull || echo "No changes to pull."
      ''}";
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
