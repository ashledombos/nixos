{ config, pkgs, ... }:

{
  # Autres configurations...

  environment.systemPackages = with pkgs; [
    # Outils de développement généraux
    git
    vscode  # ou vscodium si vous préférez

    # Python
    python3
    python3Packages.pip
    python3Packages.virtualenv

    # Node.js et TypeScript
    nodejs
    nodePackages.npm
    nodePackages.typescript

    # Autres outils utiles
    gnumake
    gcc
  ];

  # Activer le service nix-daemon pour une meilleure gestion des paquets
  services.nix-daemon.enable = true;

  # Permettre l'installation de paquets non-libres si nécessaire
  nixpkgs.config.allowUnfree = true;
}
