{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.illuminanced = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether to configure system to use illuminanced.
      '';
    };
  };

  config = lib.mkIf config.programs.illuminanced.enable {
    environment.systemPackages = [
      pkgs.illuminanced
    ];
  };
}
