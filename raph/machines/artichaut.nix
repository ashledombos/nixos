{ config, pkgs, ... }:

{

  imports = [
    ../config.nix
    ../services.nix
    ../boot-plymouth.nix
    # ../portable.nix
  ];
}
