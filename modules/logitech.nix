{pkgs, ...}: {
  hardware.logitech.wireless = {
    enable = true;
    # solaar
    enableGraphical = true;
  };

  systemd.user.services.logitech = {
    description = "user daemon for configuration of logitech devices";
    enable = true;
    script = "${pkgs.solaar}/bin/solaar -w hide";
    wantedBy = ["multi-user.target"];
  };
}
