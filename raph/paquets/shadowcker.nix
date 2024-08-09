{ pkgs, config, lib, ... }:

# NixOS configuration for Shadowcker

let
  # Download Shadowcker logo
  shadowckerIcon = pkgs.fetchurl {
    url = "https://gitlab.com/uploads/-/system/project/avatar/11800466/Shadow-2.png";
    sha256 = "7701d88c700d702c642572a07b3bdf950571974f04bc2f104beb424ce3d42482";
  };

  shadowcker = pkgs.stdenv.mkDerivation {
    name = "shadowcker-launcher";
    version = "1.0";

    src = builtins.fetchGit {
      url = "https://gitlab.com/aar642/shadowcker.git";
      # Use a specific commit hash for reproducibility
      rev = "2706e069d3f100f7e8a210bbb294b69a583716f1";
    };

    buildInputs = [ pkgs.git pkgs.makeWrapper ];

    installPhase = ''
      set -euo pipefail

      mkdir -p $out/bin
      cp ${./shadowcker-launch.sh} $out/bin/shadowcker
      chmod +x $out/bin/shadowcker

      # Substitute variables directly in the script
      substituteInPlace $out/bin/shadowcker --replace "src_dir" "${shadowcker.src}"

      # Copy icon to output directory
      mkdir -p $out/share/icons/hicolor/64x64/apps
      cp ${shadowckerIcon} $out/share/icons/hicolor/64x64/apps/shadowcker.png
    '';

    meta = with pkgs.lib; {
      description = "Shadow client launcher for NixOS with version management and auto-update";
      homepage = "https://gitlab.com/aar642/shadowcker";
      license = licenses.mit;
      maintainers = with maintainers; [ "aar642" ];
    };
  };

  # Common path for the icon
  shadowckerIconPath = "${shadowcker}/share/icons/hicolor/64x64/apps/shadowcker.png";

  # Define the desktop entries
  shadowMenuEntries = lib.concatMap (entry: [
    pkgs.writeTextFile {
      name = "shadowcker-${entry.name}.desktop";
      text = ''
        [Desktop Entry]
        Name=${entry.desktopName}
        Exec=${entry.exec}
        Icon=${entry.icon}
        Type=Application
        Categories=${entry.categories}
        Comment=${entry.comment}
      '';
    }
  ]) [
    {
      name = "Shadow Stable";
      exec = "${shadowcker}/bin/shadowcker stable";
      icon = shadowckerIconPath;
      desktopName = "Shadow (Stable)";
      comment = "Launches the stable version of the Shadow client";
      categories = "Network;RemoteAccess;";
    }
    {
      name = "Shadow Beta";
      exec = "${shadowcker}/bin/shadowcker beta";
      icon = shadowckerIconPath;
      desktopName = "Shadow (Beta)";
      comment = "Launches the beta version of the Shadow client";
      categories = "Network;RemoteAccess;";
    }
    {
      name = "Shadow Alpha";
      exec = "${shadowcker}/bin/shadowcker alpha";
      icon = shadowckerIconPath;
      desktopName = "Shadow (Alpha)";
      comment = "Launches the alpha version of the Shadow client";
      categories = "Network;RemoteAccess;";
    }
  ];

in
{
  # Configure and enable Docker
  services.docker = {
    enable = true;
    enableUserServices = true;
  };

  # Ensure the user is in the Docker group
  users.extraGroups.docker.members = [ "<username>" ]; # Replace <username> with the appropriate username

  # Enable the X server
  services.xserver.enable = true;

  # Enable OpenGL support
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # Add the shadowcker package and dependencies to the system environment
  environment.systemPackages = with pkgs; [
    shadowcker
    git
    docker
    docker-compose
    gnumake
    xorg.xhost
  ];

  # Ensure desktop entries are included in the system configuration
  environment.etc."xdg/share/applications".source = shadowMenuEntries;

  # Add an alias to easily use the script
  environment.etc."profile.d/shadowcker.sh".text = ''
    export PATH=$PATH:${config.system.build.toplevel}/bin
  '';
}
