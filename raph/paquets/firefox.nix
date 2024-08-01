{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        # Support de la synthèse vocale
        speechSynthesisSupport = true;
        # Activation de Widevine pour le support DRM
        enableWideVine = true;
        # Activation du support du rapporteur de plantage
        crashreporterSupport = true;
        # Activation du support de PipeWire
        pipewireSupport = true;
      };
    };
  };

  # Configuration de la langue pour Firefox
  environment.variables = {
    LANGUAGE = "fr_FR:fr";
  };
}
