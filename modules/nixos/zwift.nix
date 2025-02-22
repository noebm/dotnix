{
  inputs,
  ...
}:
{
  # programs.zwift.enable = true;
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
  };
  environment.systemPackages = [ inputs.zwift.packages.x86_64-linux.zwift ];
}
