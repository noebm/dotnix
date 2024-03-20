{pkgs, ...}: {
  systemd.services.hd-idle = {
    description = "External HD spin down daemon";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.hd-idle}/bin/hd-idle -i 0 -a sdb -i 600";
    };
  };
}
