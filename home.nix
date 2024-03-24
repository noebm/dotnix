{
  pkgs,
  nixvim,
  ...
}: let
  flakes = [
    nixvim.homeManagerModules.nixvim
  ];
  home-modules = [
    ./home-modules/gitignore.nix
    ./home-modules/nvim.nix
  ];
in {
  imports = flakes ++ home-modules;
  home.packages = with pkgs; [
    firefox
    tree
    discord
    lutris
    steam
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

  home.stateVersion = "23.11";
}
