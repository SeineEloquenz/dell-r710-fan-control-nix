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
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ dell-fan-control ];

    systemd.services."dell-fan-control" = {
      enable = true;

      description = "Runs dell-fan-control.";
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${dell-fan-control}/bin/dell-fan-control";
        Restart = "always";
        RestartSec = "15";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
