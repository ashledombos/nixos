# Les paquets qui servent ou peuvent servir dans tous les cas

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    rustdesk-flutter
    vim
    inxi
    wget
  ];

}
