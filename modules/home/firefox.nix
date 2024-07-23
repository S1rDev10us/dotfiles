{
  opts,
  lib,
  user,
  ...
}:
lib.mkIf opts.GUI.enable {
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      name = user;
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
      HttpsOnlyMode = "enabled";
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
    };
  };
}
