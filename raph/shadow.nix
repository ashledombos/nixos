{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    docker-compose
    gnumake
    xorg.xhost
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "raphael" ];

  # Ajouter des services Docker et Docker Compose
  services.docker.enable = true;

  # Unité de service systemd pour cloner le dépôt et exécuter `make stable`
  systemd.services.shadowcker-setup = {
    description = "Clone shadowcker repository and build stable version";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.git}/bin/git clone https://gitlab.com/aar642/shadowcker.git /home/raphael/Programmes/shadowcker";
      ExecStartPost = "${pkgs.make}/bin/make -C /home/raphael/Programmes/shadowcker stable";
    };
  };

  # Unité de service systemd pour autoriser les connexions X11 locales pour root
  systemd.services.xhost-local-root = {
    description = "Allow local root access to X server";
    after = [ "display-manager.service" ];
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.xorg.xhost}/bin/xhost +local:root";
      RemainAfterExit = true;
    };
  };

  # Créer un script pour `make start`
  systemd.services.shadowcker-start-script = {
    description = "Create a script to run `make start` for shadowcker";
    after = [ "shadowcker-setup.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        echo '#!/bin/sh' > /home/raphael/Programmes/shadowcker/start.sh
        echo 'cd /home/raphael/Programmes/shadowcker && make start' >> /home/raphael/Programmes/shadowcker/start.sh
        chmod +x /home/raphael/Programmes/shadowcker/start.sh
      '';
    };
  };

  # Ajouter un raccourci sur le bureau pour exécuter `make start`
  environment.etc."xdg/autostart/shadowcker.desktop".text = ''
    [Desktop Entry]
    Name=Start Shadowcker
    Exec=/home/raphael/Programmes/shadowcker/start.sh
    Type=Application
    Terminal=true
  '';

  # Ajouter un alias pour `make start`
  environment.systemPackages = [ pkgs.shadow-utils ];
  users.users.raphael = {
    isNormalUser = true;
    extraGroups = [ "docker" ]; # Ajouter l'utilisateur raphael au groupe docker
    shell = pkgs.bashInteractive;
    createHome = true;
    home = "/home/raphael";
    extraGroups = [ "wheel" "docker" ]; # Ajouter l'utilisateur raphael aux groupes wheel et docker
    postCreate = ''
      ln -sf /home/raphael/Programmes/shadowcker/start.sh /home/raphael/.local/bin/shadowcker-start
    '';
  };
}

}
