{pkgs, ...}: {
  imports = [
    ./plasma.nix
    # ./hyprland.nix
  ];
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.videoDrivers = ["amdgpu"];

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  services.displayManager.defaultSession = "plasmawayland";

  # required for wayland
  security.polkit.enable = true;
}
