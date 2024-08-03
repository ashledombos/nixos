{ config, pkgs, ... }:

{
  # Import the shadow-nix package from the forked repository
  imports = [
    (fetchGit {
      url = "https://github.com/cornerman/shadow-nix";
      ref = "main";  # Use the latest commit from the main branch
    } + "/import/system.nix")
  ];

  programs.shadow-client = {
    enable = true;  # Enable the Shadow client
    channel = "prod";  # Set the channel to use
  };

  # Optional: Configure VAAPI for better performance
  environment.systemPackages = with pkgs; [ libva-utils ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ vaapiIntel vaapiVdpau libvdpau-va-gl intel-media-driver ];
  };
}
