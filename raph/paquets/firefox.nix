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

  # Configuration globale pour Firefox avec les extensions
  environment.etc."firefox/policies/policies.json".text = builtins.toJSON {
    policies = {
      DisableTelemetry = true;
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        # Decentraleyes
        "jid1-BoFifL9Vbdl2zQ@jetpack" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi";
        };
        # Textarea Cache
        "textarea-cache@nikola.dev" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/textarea-cache/latest.xpi";
        };
        # SuperAgent (si disponible, vérifiez l'ID correct)
        # "superagent@example.com" = {
        #   installation_mode = "normal_installed";
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/superagent/latest.xpi";
        # };
      };
    };
  };
}
