{pkgs, ...}: {
  imports = [
    ./plasma.nix
  ];
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.videoDrivers = ["amdgpu"];

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;

  services.xserver.displayManager.defaultSession = "plasmawayland";

  # required for wayland
  security.polkit.enable = true;
}
