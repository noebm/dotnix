{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nix-search-cli
  ];

  nix.optimise = {
    automatic = true;
    dates = ["weekly"];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
