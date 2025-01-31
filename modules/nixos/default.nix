{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./keyboard.nix
    ./development.nix
    ./nix-utils.nix
    ./bash.nix
  ];

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
  ];
}
