{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./keyboard.nix
    ./development.nix
    ./nix-utils.nix
    ./bash.nix
    ./illuminanced.nix
  ];

  nixpkgs.overlays =
    let
      pkgOverlay = import ../../pkgs/overlay.nix;
    in
    [ pkgOverlay ];

  nixpkgs.config.allowUnfree = true;

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
}
