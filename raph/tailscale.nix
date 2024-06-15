{ config, lib, pkgs, ... }:

{
  imports = [];

  # Rendre la commande tailscale utilisable pour les utilisateurs
  environment.systemPackages = [ pkgs.tailscale ];

  # Activer le service Tailscale
  services.tailscale.enable = true;

  };

  # Configurer le pare-feu
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ 41641 ]; # Port UDP standard de Tailscale
    allowedTCPPorts = [ 22 ]; # Port SSH
  };

  # Assurer que le service SSH est actif
  services.openssh.enable = true;
}
