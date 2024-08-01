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
    
    profiles = {
      default = {
        id = 0;
        name = "Défaut";
        isDefault = true;
        settings = {
          "intl.locale.requested" = "fr";
          # "intl.accept_languages" = "fr,fr-FR,en-US,en";
          
          # Paramètres de confidentialité
          # "privacy.donottrackheader.enabled" = true;
          # "privacy.trackingprotection.enabled" = true;
          # "privacy.trackingprotection.socialtracking.enabled" = true;
          
          # Désactiver Pocket
          "extensions.pocket.enabled" = false;
          
          # Activer HTTPS-Only Mode
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          
          # Autres paramètres personnalisés
          # "browser.startup.homepage" = "https://www.mozilla.org/fr/firefox/new/";
          "browser.search.region" = "FR";
          "browser.search.isUS" = false;
        };
      };
    };
    
    policies = {
      # DisableTelemetry = true;
      # DisableFirefoxStudies = true;
      # DisablePocket = true;
      # OverrideFirstRunPage = "";
      # OverridePostUpdatePage = "";
      # DontCheckDefaultBrowser = true;
      SearchEngines = {
        Default = "DuckDuckGo";
      #  PreventInstalls = true;
      };
    };
  };

  # Activer Speech Dispatcher
  services.speech-dispatcher = {
    enable = true;
  };

  # Ajouter Speech Dispatcher aux paquets système
  environment.systemPackages = with pkgs; [
    speech-dispatcher
  ];
}
