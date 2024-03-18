{pkgs, ...}: {
  services.printing.enable = true;

  # network discovery
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
}
