{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./keyboard.nix
    ./development.nix
    ./nix-utils.nix
    ./bash.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.command-not-found.enable = true;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

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
