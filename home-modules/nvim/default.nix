{pkgs, ...}: {
  imports = [
    ./agda.nix
  ];
  programs.nixvim = let
    config = import ../../nvim.nix;
  in
    config
    // {
      enable = true;
    };
}
