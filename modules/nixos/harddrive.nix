{pkgs, ...}: {
  systemd.services.hd-idle = {
    description = "External HD spin down daemon";
    wantedBy = ["multi-user.target"];
    script = "${pkgs.hd-idle}/bin/hd-idle";
  };
}
