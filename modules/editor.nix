{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.nixosModules.nixvim
    ../nvim.nix
  ];
  programs.nixvim.defaultEditor = true;
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
