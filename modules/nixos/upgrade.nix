{ inputs, ... }:
{

  system.autoUpgrade = {
    enable = true;
    flake = "github:noebm/dotnix";
    # use package versions in the repo since there is a already an upgrade action running
    flags = [
      "--no-write-lock-file"
    ];
    dates = "14:00";
    randomizedDelaySec = "45min";
  };

}
