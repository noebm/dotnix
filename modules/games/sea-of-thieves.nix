{...}: {
  # ports required for steam version of "sea of thieves"
  # according to https://portforward.com/sea-of-thieves/
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # 3074
      # 27015
      27035
      # 27036
    ];
    # allowedUDPPorts = [
    #   88
    #   500
    #   3074
    #   3544
    #   4500
    #   27015
    # ];

    # allowedUDPPortRanges = [
    #   {
    #     from = 27031;
    #     to = 27036;
    #   }
    # ];
  };
}
