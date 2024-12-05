{pkgs, ...}: {
  programs.direnv.enable = true;
  environment.systemPackages = with pkgs; [
    tmux
    jq
    git
    gcc
    clang
    glib.bin
  ];
}
