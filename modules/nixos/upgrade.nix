{ inputs, ... }:
{

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
    dates = "14:00";
    randomizedDelaySec = "45min";
  };

}
