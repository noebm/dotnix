{pkgs, ...}: {
  imports = [
    ./plasma.nix
    # ./hyprland.nix
  ];

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # required for wayland
  security.polkit.enable = true;
}
