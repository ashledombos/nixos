{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        enableTridactylNative = true;
        speechSynthesisSupport = true;
      };
    };
  };

  # Configuration de la langue pour Firefox
  environment.variables = {
    LANGUAGE = "fr_FR:fr";
  };
}
