{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.illuminanced;

  settingsFormat = pkgs.formats.toml { };
  settingsFile = settingsFormat.generate "illuminanced.toml" {
    daemonize = {
      log_to = "syslog";
      log_level = "TRACE";
      # pid_file = cfg.settings.PIDFile;
    };

    general = {
      check_period_in_seconds = 1;
      light_steps = 10;
      step_barrier = 0.1;
      min_backlight = 20;
      enable_max_brightness_mode = true;

      max_backlight_file =
        if cfg.settings.device == "frameworks13" then
          "/sys/class/backlight/amdgpu_bl1/max_brightness"
        else
          throw "Unknown device!";

      backlight_file =
        if cfg.settings.device == "frameworks13" then
          "/sys/class/backlight/amdgpu_bl1/brightness"
        else
          throw "Unknown device!";

      illuminance_file =
        if cfg.settings.device == "frameworks13" then
          "/sys/bus/iio/devices/iio:device0/in_illuminance_raw"
        else
          throw "Unknown device!";

    };

    kalman = {
      q = 1;
      r = 20;
      covariance = 10;
    };

    light =
      with lib.lists;
      with lib.attrsets;
      {
        points_count = builtins.length cfg.settings.light;
      }
      // builtins.listToAttrs (
        imap0 (idx: mapAttrs' (name: nameValuePair (name + "_${idx}"))) cfg.settings.light
      );
  };
in
{
  options = {
    programs.illuminanced = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to configure system to use illuminanced.
        '';
      };
    };

    services.illuminanced = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to configure system to run illuminanced as service.
        '';
      };

      settings = {
        # PIDFile = lib.mkOption {
        #   default = /run/illuminanced.pid;
        #   type = lib.types.path;
        #   description = ''
        #     Location of the pid file.
        #   '';
        # };

        device = lib.mkOption {
          type = lib.types.enum [ "frameworks13" ];
          description = ''
            Device name used to select sysfs interfaces.
          '';
        };

        light = lib.mkOption {
          type =
            let
              entries = lib.types.submodule {
                options = {
                  illuminance = lib.mkOption {
                    type = lib.types.int;
                  };
                  light = lib.mkOption {
                    type = lib.types.int;
                  };
                };
              };
            in
            lib.types.listOf entries;

          default = [
            {
              illuminance = 0;
              light = 0;
            }
            {
              illuminance = 20;
              light = 1;
            }
            {
              illuminance = 300;
              light = 3;
            }
            {
              illuminance = 700;
              light = 4;
            }
            {
              illuminance = 1100;
              light = 5;
            }
            {
              illuminance = 7100;
              light = 10;
            }
          ];

          description = ''
            Configuration of the brightness light level from illuminance.
          '';

        };

      };

    };
  };

  config = lib.mkIf (config.programs.illuminanced.enable || config.services.illuminanced.enable) {
    environment.systemPackages = lib.mkIf config.programs.illuminanced.enable [
      pkgs.illuminanced
    ];

    # Service based on `illuminanced.service` in github repo.
    systemd.services = lib.mkIf config.services.illuminanced.enable {
      illuminanced = {
        description = "Ambient light monitoring Service";
        requires = [ "syslog.socket" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          # Type = "forking";
          Restart = "on-failure";
          ExecStart = "${pkgs.illuminanced} --config ${settingsFile} --no-fork";
        };
      };

    };
  };
}
