{
  lib,
  systemConfig,
  pkgs,
  ...
}: {
  options = lib.mkIf (!systemConfig.headless) {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-bin;
      policies = {
        DisablePocket = true;
        DisableTelemetry = true;
        FirefoxHome = {
          Search = true;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = false;
          SearchEngines.Default = "DuckDuckGo";
          DisableFirefoxStudies = true;
          Extensions.Install = ["https://addons.mozilla.org/firefox/downloads/file/4237670/ublock_origin-1.56.0.xpi"];
        };
      };
    };
  };
}
