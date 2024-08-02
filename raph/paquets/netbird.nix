{ config, lib, pkgs, ... }:

{
  imports = [];

  # Rendre la commande tailscale utilisable pour les utilisateurs
  environment.systemPackages = [ pkgs.netbird-ui ];

  # Activer le service Tailscale
  services.netbird.enable = true;

  # Configurer le pare-feu
  networking.firewall = {
    trustedInterfaces = [ "netbird0" ];
    allowedTCPPorts = [ 22 ]; # Port SSH
  };

  # Assurer que le service SSH est actif
  services.openssh.enable = true;
}
