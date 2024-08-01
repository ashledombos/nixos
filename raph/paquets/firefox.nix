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

  # Activer Speech Dispatcher
  services.speech-dispatcher.enable = true;

  # Ajouter Speech Dispatcher aux paquets système
  environment.systemPackages = with pkgs; [
    speech-dispatcher
  ];

  # Configuration globale pour Firefox (optionnel)
  # environment.etc."firefox/policies/policies.json".text = builtins.toJSON {
  #   policies = {
  #    DisableTelemetry = true;
  #    DisableFirefoxStudies = true;
  #    DisablePocket = true;
  #    OverrideFirstRunPage = "";
  #    OverridePostUpdatePage = "";
  #    DontCheckDefaultBrowser = true;
  #    DefaultSearchProviderName = "DuckDuckGo";
  #    DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
  #  };
  #};
}
