{ config, pkgs, ... }:

{
  # Installation de Podman - c'est essentiel pour démarrer
  environment.systemPackages = with pkgs; [
    podman
    xorg.xhost
  ];

  # Activation de Podman - c'est également essentiel pour que Podman fonctionne correctement
  virtualisation.podman.enable = true;

  # Ces options sont pour un usage plus avancé ou des configurations spécifiques :
  # Elles ne sont pas nécessaires pour démarrer un conteneur Debian de base.
  # Elles peuvent être activées plus tard si besoin.

  # Gestion des réseaux Podman - optionnel pour des configurations réseau personnalisées
  # virtualisation.podman.defaultNetworkSettings = {
  #   defaultSubnet = "10.88.0.0/16";
  #   manageFirewall = false;
  # };

  # Utilisation sans privilèges root (rootless) - optionnel pour des configurations de sécurité avancées
  # virtualisation.podman.userNamespace = true;

  # Activation des modules kernel pour USB et Bluetooth - utile si tu veux gérer ces périphériques depuis le conteneur
  # boot.kernelModules = [
  #   "usbcore"
  #   "usb_common"
  #   "btusb" # Pour Bluetooth
  # ];

  # Capacités supplémentaires pour Podman - utile pour des conteneurs qui nécessitent des privilèges système spécifiques
  # security.rtkit = {
  #   enable = true;
  #   extraKernelCapabilities = ["NET_ADMIN" "SYS_ADMIN"];
  # };

  # Configuration du pare-feu - optionnel, à ajuster en fonction de tes besoins en sécurité
  # networking.firewall.enable = true;

  # Option pour l'utilisateur - utile si tu veux utiliser Podman sans les droits root
  # users.users.yourusername = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" "docker" "podman" ]; # Ajoute l'utilisateur aux groupes pour accéder à Podman
  # };

  # Services réseau optionnels - Avahi et Bluetooth, pas nécessaires pour démarrer un conteneur de base
  # services.avahi = {
  #   enable = true;
  #   nssmdns = true;
  # };
  # services.bluetooth.enable = true;

  # Gestion du conteneur au démarrage - utile si tu veux automatiser le démarrage du conteneur avec le système
  # systemd.services."podman-container-debian" = {
  #   description = "Podman Container for Debian";
  #   after = [ "network.target" ];
  #   wants = [ "network.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.podman}/bin/podman start -a debian-container";
  #     ExecStop = "${pkgs.podman}/bin/podman stop debian-container";
  #     Restart = "always";
  #   };
  #   install = {
  #     WantedBy = [ "multi-user.target" ];
  #   };
  # };
}
