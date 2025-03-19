{ pkgs, ... }:
{

  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };

  environment.systemPackages = with pkgs; [
    glxinfo
    vulkan-tools
  ];

}
