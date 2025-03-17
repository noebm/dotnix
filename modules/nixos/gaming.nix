{
  pkgs,
  inputs,
  system,
  ...
}:
{
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [ torzu ];

  # minecraft
  # environment.systemPackages = [
  #   pkgs.prismlauncher
  # ];
}
