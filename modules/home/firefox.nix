{
  opts,
  lib,
  user,
  inputs,
  pkgs,
  ...
}:
lib.mkIf opts.GUI.enable {
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
        inherit extensions;
        settings = {
          "extensions.autoDisableScopes" = 0;
        };
        search = {
          default = "DuckDuckGo";
          force = true;
          engines = {
            Bing.metaData.hidden = true;
            Google.metaData.hidden = true;
            eBay.metaData.hidden = true;
            Github = {
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
              iconUpdateUrl = "https://github.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
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
      HttpsOnlyMode = "force_enabled";
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
    };
  };
}
