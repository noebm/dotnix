{...}: let
  lock-value = value: {
    Value = value;
    Status = "locked";
  };
  firefox-extension-url = name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
in {
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      SearchBar = "unified";

      Preferences = {
        # Privacy settings
        "extensions.pocket.enabled" = lock-value false;
        "browser.newtabpage.pinned" = lock-value "";
        "browser.topsites.contile.enabled" = lock-value false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-value false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-value false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-value false;
        # Disable Privacy-Preserving Attribution (PPA) for privacy
        # PPA is enabled by default in Firefox 128
        # See: https://news.ycombinator.com/item?id=40974112
        "dom.private-attribution.submission.enabled" = lock-value false;
        # Enable custom search engines
        # See: https://superuser.com/questions/7327/how-to-add-a-custom-search-engine-to-firefox/1756774#1756774
        "browser.urlbar.update2.engineAliasRefresh" = lock-value true;
      };

      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = firefox-extension-url "ublock-origin";
          installation_mode = "force_installed";
        };
        # SponsorBlock for YouTube
        "sponsorBlocker@ajay.app" = {
          install_url = firefox-extension-url "sponsorblock";
          installation_mode = "force_installed";
        };
        # Reddit Enhancement Suite
        "jid1-xUfzOsOFlzSOXg@jetpack" = {
          install_url = firefox-extension-url "reddit-enhancement-suite";
          installation_mode = "force_installed";
        };
        # Privacy Badger
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = firefox-extension-url "privacy-badger17";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
