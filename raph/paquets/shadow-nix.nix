{ config, pkgs, ... }:

{

  imports = [
    (fetchGit { url = "https://github.com/cornerman/shadow-nix"; ref = "refs/tags/v2.0.2"; } + "/import/system.nix")
  ];

  programs.shadow-client = {
    # Enabled by default when using import
    # enable = true;
    channel = "prod";
  };

  # Provides the `vainfo` command
  environment.systemPackages = with pkgs; [ libva-utils ];

  # Hardware hybrid decoding
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  # Hardware drivers
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };

}

