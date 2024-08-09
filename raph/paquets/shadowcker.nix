{ pkgs, config, lib, ... }:

# Comment to guide users
# Add users to the "docker" group to allow Shadowcker access, eg.:
# users.users.<username>.extraGroups = [ "network-manager" "wheel" "docker" ];

let
  # Shadowcker logo download
  shadowckerIcon = pkgs.fetchurl {
    url = "https://gitlab.com/uploads/-/system/project/avatar/11800466/Shadow-2.png";
    sha256 = "7701d88c700d702c642572a07b3bdf950571974f04bc2f104beb424ce3d42482";
  };

  shadowcker = pkgs.stdenv.mkDerivation {
    name = "shadowcker-launcher";
    version = "1.0";

    src = builtins.fetchGit {
      url = "https://github.com/aar642/shadowcker.git";
      rev = "master";
      # Replace master with a "commit-hash" to pin to a specific commit
      # ref = "2706e069d3f100f7e8a210bbb294b69a583716f1";
    };

    buildInputs = [ pkgs.git pkgs.makeWrapper ];

installPhase = ''
  mkdir -p $out/bin
  cat > $out/bin/shadowcker << 'EOF'
#!/usr/bin/env bash

# Choose the version of the client to launch (stable, beta, alpha)
client_version='${1:-stable}'

# Function to launch the Shadow client
launch_shadow() {
  make $client_version
  make start
}

# Check if the local git repository is up to date
cd ${src}

# Check connectivity with the remote repository
if git ls-remote &> /dev/null; then
  # Update the local repository if there are changes
  git fetch origin
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse origin/master)

  if [ $LOCAL != $REMOTE ]; then
    echo "Local repository is not up-to-date. Updating..."
    git pull origin master
    make clean
    launch_shadow
  else
    echo "Local repository is up-to-date."
    launch_shadow
  fi
else
  echo "Unable to reach the remote repository. Launching the client with the local version..."
  launch_shadow
fi
EOF
  chmod +x $out/bin/shadowcker

  # Copier l'icône dans le répertoire de sortie
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

  # Créer les entrées de menu pour différentes versions de Shadow
  shadowMenuEntries = lib.concatMap (entry: [
    pkgs.writeTextFile {
      name = "shadowcker-${entry.name}.desktop";
      destination = "${config.system.build.toplevel}/share/applications";
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
      icon = "${shadowcker}/share/icons/hicolor/64x64/apps/shadowcker.png";
      desktopName = "Shadow (Stable)";
      comment = "Launches the stable version of the Shadow client";
      categories = "Network;RemoteAccess;";
    }
    {
      name = "Shadow Beta";
      exec = "${shadowcker}/bin/shadowcker beta";
      icon = "${shadowcker}/share/icons/hicolor/64x64/apps/shadowcker.png";
      desktopName = "Shadow (Beta)";
      comment = "Launches the beta version of the Shadow client";
      categories = "Network;RemoteAccess;";
    }
    {
      name = "Shadow Alpha";
      exec = "${shadowcker}/bin/shadowcker alpha";
      icon = "${shadowcker}/share/icons/hicolor/64x64/apps/shadowcker.png";
      desktopName = "Shadow (Alpha)";
      comment = "Launches the alpha version of the Shadow client";
      categories = "Network;RemoteAccess;";
    }
  ];

in
{
  # Install Docker and configure it
  services.docker = {
    enable = true;
    enableUserServices = true;
  };

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "user" ];

  services.xserver.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # Add the shadowcker package to the system environment
  environment.systemPackages = lib.mkMerge [
    [
      shadowcker
      pkgs.git  # Ensure git is installed
      pkgs.docker  # Ensure docker is installed
      docker-compose
      gnumake
      xorg.xhost
    ]
    shadowMenuEntries
  ];

  # Add an alias to easily use the script
  environment.etc."profile.d/shadowcker.sh".text = ''
    export PATH=$PATH:${config.system.build.toplevel}/bin
  '';
}
