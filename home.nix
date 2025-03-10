{
  pkgs,
  inputs,
  system,
  ...
}: {

  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./modules/home/sops.nix
    ./modules/home/git.nix
    ./modules/home/firefox.nix
    ./modules/home/shell.nix
  ];

  home.packages = with pkgs; [
    inputs.dotnvim.packages.${system}.nvim

    home-manager

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
