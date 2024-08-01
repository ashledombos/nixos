# Configuration générique pour les postes de bureau ou portables
# en français et avec interface graphique
# Pour l’instant deux environnements de bureau sont pris en charge
# KDE Plasma et Deepin OS


{ pkgs, config, ... }:

{

  # Import des fichiers communs
  imports = [
    ./services.nix
    ./boot-plymouth.nix
    ./tailscale.nix
    paquets/paquets-communs.nix
  ];

  # Gestion du démarrage.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Activer networkmanager pour permettre à l’utilisateur de gérer son gestionnaire de réseau
  networking.networkmanager.enable = true;

  # Activer les services de géolocalisation (pour les déplacements à l’étranger ou outremer)
  services.geoclue2.enable = true;

  # Activer la détection automatique du fuseau horaire
  services.localtime.enable = true;

  # Par défaut heure de la métropole.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Activer le son avec pipewire et non pulseaudio.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Services à activer
  services.openssh.enable = true;

  # Ouvrir des ports dans le pare-feu
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Créer une commande de mise à jour git et rebuild
  environment.shellAliases = {
    nix-git-rebuild = "(cd /etc/nixos/git/nixos && sudo git pull && sudo nixos-rebuild switch) && cd -";
  };
  
}
