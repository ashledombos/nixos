{ config, pkgs, lib, ... }:

let
  gitRepo = "/etc/nixos/git/nixos";
  gitPullScript = pkgs.writeShellScriptBin "git-pull" ''
    cd "${gitRepo}"
    git fetch --dry-run 2>&1 | grep -q -v 'up to date' && git pull || echo "No changes to pull."
  '';
in
{
  systemd.services.git-pull = {
    description = "Git repository auto-update";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = gitPullScript;
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.timers.git-pull = {
    description = "Periodically pull git repository";
    partOf = [ "git-pull.service" ];
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "hourly";
  };

  systemd.services.nix-gc-optimize = {
    description = "Nix Garbage Collect and Store Optimization";
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${pkgs.writeScript "nix-maintenance" ''
      ${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 30d
      ${pkgs.nix}/bin/nix-store --optimize
    ''}";
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

  system.autoUpgrade = {
    enable = true;
    dates = "Sun *-*-* 21:30:00"; # Mise à jour automatique chaque dimanche à 21:30
  };

  systemd.timers.auto-upgrade = {
    timerConfig.Persistent = true;
    wantedBy = [ "timers.target" ];
  };
}
