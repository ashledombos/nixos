{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vscodium

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
}
