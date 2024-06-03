{ config, pkgs, ... }:

{
  # Configuration de SDDM
  services.displayManager.sddm = {
    # autoLogin.enable = false;
    # theme = "breeze";  # Thème par défaut, ajustez selon besoins
    settings = {
      General = {
        # Définir l'environnement de greeter pour utiliser le français
        GreeterEnvironment = "LANG=fr_FR.UTF-8";
        # Activer le pavé numérique
        Numlock = "on";
      };
    };
  };


  # Paramètres pour zram avec systemd
  #services.zram-generator.enable = true;
  #services.zram-generator.settings = {
  #  zram0 = {
  #    host-memory-limit = "none";  # Pas de limite spécifique à la mémoire hôte
  #    zram-fraction = 0.5;  # Utiliser 50% de la mémoire RAM disponible pour zram
  #    max-zram-size = "8192";  # Taille maximale de zram à 8192 MiB
  #    compression-algorithm = "lzo-rle";  # Algorithme de compression recommandé
  #  };
  #};

  # Power management
  #powerManagement.enable = true;
  #boot.kernelModules = [ "zram" ];
  #boot.initrd.availableKernelModules = [ "zram" ];
  #boot.initrd.kernelModules = [ "zram" ];
  #boot.resumeDevice = "/dev/disk/by-uuid/bf81d449-7430-425a-b3f9-46e8de342731";
  #boot.kernelParams = [
  #  "resume=UUID=bf81d449-7430-425a-b3f9-46e8de342731"
  #  "resume_offset=64223232"
  #];
  #systemd.sleep.extraConfig = ''
  #  HibernateDelaySec=30s # very low value to test suspend-then-hibernate
  # SuspendState=mem #standby freeze # suspend2idle is buggy :(
  #'';

  # Enable Discover and Flatpak
  services.fwupd.enable = true;
  services.flatpak.enable = true;
  services.packagekit.enable = true;
  xdg.portal.extraPortals = 
    [ pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-kde
    ];
  # xdg.portal.config.common.default = "kde";

  # Active les mises à jour automatiques avec persistance
  system.autoUpgrade = {
    enable = true;
    dates = "Sun *-*-* 21:30:00";  # Chaque samedi à 02:00 AM
  };

  systemd.timers.auto-upgrade = {
    timerConfig.Persistent = true;  # Assure que les tâches manquées sont rattrapées
  };

  # Active le nettoyage automatique du store Nix
  systemd.services.nix-gc-optimize = {
    description = "Nix Garbage Collect and Store Optimization";
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
    wantedBy = [ "multi-user.target" ];
  };

  systemd.timers.nix-gc-optimize = {
    description = "Weekly timer for Nix garbage collection and optimization";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun 21:30:00";
      Persistent = true;
    };
  };

  # Activer Plymouth
  # boot.plymouth.enable = true;

  # Choisir un thème pour Plymouth
  # boot.plymouth.theme = "fade-in";  # Choisir parmi d'autres thèmes disponibles

  # Configurer SDDM avec Plymouth
  # services.xserver.displayManager.sddm.enable = true;

  # Assurer que Plymouth est utilisé avec SDDM
  # services.xserver.displayManager.sddm.enablePlymouthIntegration = true;

  # Configuration de base pour Xserver
  # services.xserver.enable = true;
  # services.xserver.layout = "fr";
  # services.xserver.xkbOptions = "eurosign:e";

  # Option pour le chargeur de démarrage, GRUB dans cet exemple
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.gfxmode = "auto";
  # boot.loader.grub.gfxpayloadLinux = "keep";

  # Définir un fond pour GRUB (facultatif)
  # boot.loader.grub.background = "/path/to/your/background.png";  # Assurez-vous que ce chemin est correct

  boot.plymouth.enable = true;

let
  adi1090xPlymouthThemes = pkgs.adi1090x-plymouth-themes.override {
    selected_themes = [ "rings_2" ];
  };
in {
  # Activer Plymouth
  boot.plymouth.enable = true;
  boot.plymouth.theme = "rings_2";
}
