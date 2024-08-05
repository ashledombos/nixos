{ config, pkgs, ... }:

{
  imports = [
    (import (fetchGit {
      url = "https://github.com/anthonyroussel/shadow-nix";
      ref = "refs/tags/v1.5.0";
    }) + "/import/system.nix")
  ];

  programs.shadow-client = {
    channel = "prod";
  };

  environment.systemPackages = with pkgs; [ libva-utils ];

  #nixpkgs.config.packageOverrides = pkgs: {
  #  vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  #};

  #hardware.opengl = {
  #  enable = true;
  #  extraPackages = with pkgs; [
  #    vaapiIntel
   #   vaapiVdpau
  #    libvdpau-va-gl
  #    intel-media-driver
  #  ];
  #};

  #environment.sessionVariables = {
  #  LIBVA_DRIVER_NAME = "iHD";
  #};
}

