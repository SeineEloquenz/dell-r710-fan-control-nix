{ config
, pkgs
, lib
, ... }:

let

  cfg = config.services.dell-fan-control;
  dell-fan-control = (pkgs.callPackage ./package.nix {});

in {

  options.services.dell-fan-control = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the dell fan control service";
    };
    user = mkOption {
      type = types.str;
      default = "fanctl";
      description = "The user to run the service as";
    };
    frequency = mkOption {
      type = types.str;
      default = "15";
      description = "How often to run the script";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ dell-fan-control ];

    users.users.${cfg.user}.group = cfg.user;
    users.groups.${cfg.user} = {};

    systemd.services."dell-fan-control" = {
      enable = true;

      description = "Runs dell-fan-control.";
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${dell-fan-control}/bin/dell-fan-control";
        User = cfg.user;
        Restart = "always";
        RestartSec = cfg.frequency;
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
