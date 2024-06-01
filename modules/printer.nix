{pkgs, ...}: {
  services.printing.enable = true;

  # network discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
