{
  self,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./firefox.nix
    ./keyboard.nix
    ./development.nix
    ./nix-utils.nix
    ./bash.nix
    ./ollama.nix
    ./upgrade.nix
  ];

  system.nixos.label = "nixos-${
    toString (self.shortRev or self.dirtyShortRev or self.lastModified or "unknown")
  }";

  nixpkgs.config.allowUnfree = true;

  programs.command-not-found.enable = true;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  fonts.packages =
    if pkgs.lib.versionAtLeast config.system.nixos.version "25.05" then
      with pkgs; [ nerd-fonts.droid-sans-mono ]
    else
      with pkgs; [ nerdfonts ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    curl
    unzip
    zip
    alacritty
    wl-clipboard
    lm_sensors
  ];

  # use european measurements for time, units etc.
  i18n.extraLocaleSettings = {
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
  };
}
