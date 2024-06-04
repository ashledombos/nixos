{ config, pkgs, ... }:

let
  gitRepo = "/etc/nixos/git/nixos";
in
{
  systemd.services.git-pull = {
    description = "Git repository auto-update";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScriptBin "git-pull" ''
        #!/bin/sh
        cd "${gitRepo}"
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

  systemd.services.nix-gc-optimize = {
    description = "Nix Garbage Collect and Store Optimization";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeScriptBin "nix-maintenance" ''
        #!/bin/sh
        ${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 30d
        ${pkgs.nix}/bin/nix-store --optimize
      ''}";
    };
  };

  systemd.timers.nix-gc-optimize = {
    description = "Weekly timer for Nix garbage collection and optimization";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  systemd.timers.auto-upgrade = {
    description = "Automatically upgrade NixOS system";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun *-*-* 21:30:00";
      Persistent = true;
    };
  };
}
