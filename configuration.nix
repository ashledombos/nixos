{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "artichaud"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
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
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable Discover and Flatpak
  services.fwupd.enable = true;
  services.flatpak.enable = true;
  services.packagekit.enable = true;
  xdg.portal.extraPortals = 
    [ pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-kde
    ];
#  xdg.portal.config.common.default = "kde";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "bepo_afnor";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.raphael = {
    isNormalUser = true;
    description = "Raphaël";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  ## Install firefox.
  # programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    kdePackages.discover
  ];

  # Paramètres pour zram avec systemd
  services.zram-generator.enable = true;
  services.zram-generator.settings = {
    zram0 = {
      host-memory-limit = "none";  # Pas de limite spécifique à la mémoire hôte
      zram-fraction = 0.5;  # Utiliser 50% de la mémoire RAM disponible pour zram
      max-zram-size = "8192";  # Taille maximale de zram à 8192 MiB
      compression-algorithm = "lzo-rle";  # Algorithme de compression recommandé
    };
  };

  # Power management
  powerManagement.enable = true;
  boot.kernelModules = [ "zram" ];
  boot.initrd.availableKernelModules = [ "zram" ];
  boot.initrd.kernelModules = [ "zram" ];
  boot.resumeDevice = "/dev/disk/by-uuid/bf81d449-7430-425a-b3f9-46e8de342731";
  boot.kernelParams = [
    "resume=UUID=bf81d449-7430-425a-b3f9-46e8de342731"
    "resume_offset=64223232"
  ];
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30s # very low value to test suspend-then-hibernate
    SuspendState=mem #standby freeze # suspend2idle is buggy :(
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.05"; # Did you read the comment?
}
