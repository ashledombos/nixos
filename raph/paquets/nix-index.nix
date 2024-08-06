## ne marche pas

{ config, lib, pkgs, ... }:

{

  programs.nix-index = {
  enable = true;
  enableBashIntegration = true;
  enableZshIntegration = true;
  enableFishIntegration = true;
  };

  programs.command-not-found.enable = false;

}
