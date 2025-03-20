{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      settings = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "browser.aboutConfig.showWarning" = false;
        "browser.cache.disk.enable" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "intl.accept_languages" = "en,en-us,de";
      };

      search = {
        force = true;

        default = "google";
        order = [
          "google"
          "ddg"
        ];

        engines = {
          "bing".metadata.hidden = true;
          "ecosia".metadata.hidden = true;

          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "@nix" ];
          };
          "NixOS Modules" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "@nixos" ];
          };
          "NixOS Wiki" = {
            urls = [
              {
                template = "https://nixos.wiki/index.php";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "@nixwiki" ];
          };

          "Perplexity" = {
            urls = [
              {
                template = "https://www.perplexity.ai/search/new";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "@perp" ];
          };

          "Discogs" = {
            urls = [
              {
                template = "https://www.discogs.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "@disc" ];
          };
        };

      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "default-web-browser" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
    };
  };
}
