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
