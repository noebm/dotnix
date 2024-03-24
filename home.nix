{
  pkgs,
  nixvim,
  ...
}: {
  imports = [
    ./config/gitignore.nix
    # nixvim
    nixvim.homeManagerModules.nixvim
    ./config/nvim.nix
  ];
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
