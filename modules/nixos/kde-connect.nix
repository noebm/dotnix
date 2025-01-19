{pkgs, ...}: {
  networking.firewall = {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };
  environment.systemPackages = with pkgs; [
    libsForQt5.kdeconnect-kde
  ];
}
