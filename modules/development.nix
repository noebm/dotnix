{pkgs, ...}: {
  programs.direnv.enable = true;
  environment.systemPackages = with pkgs; [
    jq
    git
    gcc
    clang
    glib.bin
  ];
}
