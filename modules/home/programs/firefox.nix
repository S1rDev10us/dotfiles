{
  opts,
  lib,
  user,
  inputs,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles = let
      extensions = with inputs.firefox-extensions.packages.${pkgs.system}; [
        noscript
        redirector
        keepassxc-browser
        ublock-origin
        facebook-container
        multi-account-containers
        # google containers # Uh, I might need to add this one manually or raise an issue for it
      ];
      baseSettings = {
        extensions.packages = extensions;
        settings = {
          "extensions.autoDisableScopes" = 0;
        };
        search = {
          default = "ddg";
          force = true;
          engines = {
            bing.metaData.hidden = true;
            google.metaData.hidden = true;
            ebay.metaData.hidden = true;
            ebay-uk.metaData.hidden = true;
            perplexity.metaData.hidden = true;
            github = {
              urls = [
                {
                  template = "https://github.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconMapObj."16" = "https://github.com/favicon.ico";
              aliases = ["@gh"];
            };
          };
        };
      };
      settingsFrom = extraSettings: let
        result = lib.recursiveUpdate baseSettings extraSettings;
        hasName = builtins.hasAttr "name" result;
      in
        lib.throwIf (!hasName) "All firefox profiles MUST have a name assigned" result;
    in {
      default = settingsFrom {
        name = user;
        isDefault = true;
      };
      comms = settingsFrom {
        id = 2;
        name = "comms";
      };
    };
    policies = {
      CaptivePortal = false;
      DisableAppUpdate = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      FirefoxHome = {
        TopSites = false;
        Highlights = false;
        Pocket = false;
        Snippets = false;
      };
      GenerativeAI = {
        Chatbot = false;
        LinkPreviews = false;
        TabGroups = false;
        Locked = false;
      };
      HttpsOnlyMode = "force_enabled";
      NetworkPrediction = false;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
    };
  };
  home.sessionVariables.BROWSER = "firefox";
}
