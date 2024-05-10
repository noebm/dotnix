{
  pkgs,
  home-manager,
  user,
  ...
}: {
  programs.hyprland.enable = true;

  # see
  # https://wiki.hyprland.org/Configuring/Example-configurations/
  # https://github.com/notusknot/dotfiles-nix/blob/main/modules/hyprland/hyprland.conf
  # for inspiration
  # home-manager.users.${user} = {
  #   programs.waybar = {
  #     enable = true;
  #     # settings = {
  #     #   position = "top";
  #     # };
  #   };
  # };

  environment.sessionVariables = {
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    # bar
    waybar

    # notifications
    dunst
    # requires
    # libnotify

    # backgrounds
    # swww
    hyprpaper

    # uplauncher
    wofi

    # password verification windows
    lxqt.lxqt-policykit
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
}
