{
  config,
  lib,
  pkgs,
  ...
}:

# Service based on `illuminanced.service` in illuminanced github repository.
#
# Notes:
# To bypass issues with global PID files we use `--no-fork` and
# use a patched version to correctly apply log levels.

let
  cfg = config.services.illuminanced;
  settingsFormat = pkgs.formats.toml { };

in
{
  options = {
    services.illuminanced = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to configure system to run illuminanced as service.
        '';
      };

      settings = {
        log_level = lib.mkOption {
          type = lib.types.enum [
            "OFF"
            "ERROR"
            "WARN"
            "INFO"
            "DEBUG"
            "TRACE"
          ];
          default = "INFO";
        };

        update_interval = lib.mkOption {
          description = "Update interval in seconds.";
          type = lib.types.int;
          default = 1;
        };

        backlight_file = lib.mkOption {
          description = "sysfs path of the backlight brightness.";
          type = lib.types.str;
        };

        max_backlight_file = lib.mkOption {
          description = "sysfs path of the backlight max brightness.";
          type = lib.types.str;
        };

        illuminance_file = lib.mkOption {
          description = "sysfs path of the raw illuminance.";
          type = lib.types.str;
        };

        kalman = {
          q = lib.mkOption {
            type = lib.types.float;
            default = 1.0;
          };
          r = lib.mkOption {
            type = lib.types.float;
            default = 20.0;
          };
          covariance = lib.mkOption {
            type = lib.types.float;
            default = 10.0;
          };
        };
        # device = lib.mkOption {
        #   type = lib.types.enum [ "frameworks13" ];
        #   description = ''
        #     Device name used to select sysfs interfaces.
        #   '';
        # };

        sensor_toggle =
          let
            sensor_toggle = lib.types.submodule {
              options = {
                name = lib.mkOption {
                  description = "Name of device to listen for events.";
                  type = lib.types.str;
                };
                mask = lib.mkOption {
                  description = "Path to device events.";
                  type = lib.types.str;
                  default = "/dev/input/event*";
                };
                max_brightness_mode = lib.mkOption {
                  description = "Add maximum brightness mode.";
                  type = lib.types.bool;
                  default = true;
                };
              };
            };
          in
          lib.mkOption {
            description = ''
              This option controls the ambient light sensor toggle.

              The configured device must be able to trigger `KEY_ALS_TOGGLE` events to cycle though sensor modes.
              The sensor modes are: AUTO, OFF and if enabled MAXIMUM.
            '';
            type = lib.types.nullOr sensor_toggle;
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

  config = lib.mkIf config.services.illuminanced.enable {

    systemd.services =
      let
        settingsFile = settingsFormat.generate "illuminanced.toml" {
          daemonize.log_level = cfg.settings.log_level;

          general =
            let
              sensor_toggle =
                if cfg.settings ? sensor_toggle && cfg.settings.sensor_toggle ? name then
                  {
                    event_device_mask = cfg.settings.sensor_toggle.mask;
                    event_device_name = cfg.settings.sensor_toggle.name;
                    enable_max_brightness_mode = cfg.settings.sensor_toggle.max_brightness_mode;
                  }
                else
                  { };
            in
            {
              check_period_in_seconds = cfg.settings.update_interval;
              light_steps = 10;
              step_barrier = 0.1;
              min_backlight = 20;
              enable_max_brightness_mode = true;

              backlight_file = cfg.settings.backlight_file;
              max_backlight_file = cfg.settings.max_backlight_file;
              illuminance_file = cfg.settings.illuminance_file;
            }
            // sensor_toggle;

          kalman = cfg.settings.kalman;

          light =
            with lib;
            let
              indexed_light_levels = lists.imap0 (
                idx: attrsets.mapAttrsToList (name: attrsets.nameValuePair (name + "_" + builtins.toString idx))
              ) cfg.settings.light;
            in
            {
              points_count = builtins.length cfg.settings.light;
            }
            // builtins.listToAttrs (lists.concatLists indexed_light_levels);
        };
      in
      {
        illuminanced = {
          description = "Ambient light monitoring Service";
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Restart = "on-failure";
            ExecStart = "${pkgs.illuminanced}/bin/illuminanced --config ${settingsFile} --no-fork";
          };
        };

      };
  };
}
