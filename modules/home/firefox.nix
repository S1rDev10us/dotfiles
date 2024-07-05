{
  opts,
  lib,
  user,
  ...
}:
lib.mkIf opts.GUI.enable {
  programs.firefox = {
    enable = true;
    profiles."${user}" = {
      isDefault = true;
      name = user;
    };
    policies = {
      DisableAppUpdate = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      HttpsOnlyMode = "enabled";
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      SearchEngines = {
        Add = [];
        Remove = ["Google" "Bing" "eBay"];
        Default = "DuckDuckGo";
      };
    };
  };
}
