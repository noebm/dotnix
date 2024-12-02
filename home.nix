{
  pkgs,
  config,
  inputs,
  system,
  ...
}: let
  home-modules = [
    (import ./home-modules/git.nix {inherit pkgs config;})
    ./home-modules/emacs.nix
    ./home-modules/firefox.nix
    ./home-modules/shell.nix
  ];
in {
  imports = home-modules;
  home.packages = with pkgs; [
    inputs.dotnvim.packages.${system}.nvim
    tree
    discord
    lutris
    wineWowPackages.stable
    # wineWowPackages.waylandFull
    yt-dlp
    mpv

    qbittorrent
    tor-browser-bundle-bin

    # language support for nvim
    python3
    cargo
    rustc
    luarocks # for nvim itself
    nodejs

    # command line calculator
    kalker
  ];

  xdg.enable = true;

  home.stateVersion = "23.11";
}
