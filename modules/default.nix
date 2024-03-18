{pkgs, ...}: {
  imports = [
    # ./editor.nix
    ./kde-connect.nix
    ./ps5-controller.nix
    ./printer.nix
  ];
}
