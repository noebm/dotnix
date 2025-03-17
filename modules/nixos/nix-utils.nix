{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nix-search-cli
    nvd
  ];

  # cant remember nvd
  environment.interactiveShellInit = ''
    alias nix-diff='nvd diff'
  '';

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };
}
