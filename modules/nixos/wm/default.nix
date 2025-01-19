{pkgs, ...}: {
  imports = [
    ./plasma.nix
    # ./hyprland.nix
  ];
  # Configure keymap in X11
  services.xserver.videoDrivers = ["amdgpu"];

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # required for wayland
  security.polkit.enable = true;
}
