{ pkgs ? import <nixpkgs> {} }:

let
  # List of dependencies
  libraries = with pkgs; [
    xorg.libX11
    xorg.libXau
    xorg.libXdmcp
    xorg.libxcb
    xorg.libXScrnSaver
    xorg.libXdamage
    xorg.libXrandr
    xorg.libXcomposite
    xorg.libXext
    xorg.libXfixes
    xorg.libXinerama
    xorg.libXi
    xorg.libXcursor
    xorg.libXtst
    libva
    libvdpau
    libglvnd
    libGL
    mesa
    gdk-pixbuf
    xwayland
    libpulseaudio
    alsa-lib
    curl
    dbus-glib
    libdbusmenu
    nspr
    nss
    libinput
    SDL2
    xdg-utils
    at-spi2-atk
    pango
    libbsd
    libxslt
  ];
in
pkgs.mkShell {
  buildInputs = libraries;

  shellHook = ''
    # Export LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
    # Force the use of X11 even on Wayland
    #export GDK_BACKEND=x11
    #export QT_QPA_PLATFORM=xcb
    #export WAYLAND_DISPLAY=
  '';
}
