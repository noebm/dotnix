{...}: {
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
    };
  };
}
