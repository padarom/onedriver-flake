{ config, lib, pkgs, ... }:
let
  cfg = config.services.onedriver;
in {
  options.services.onedriver = {
    enable = lib.mkEnableOption "Onedriver service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.onedriver;
      defaultText = "pkgs.onedriver";
      description = "Which onedriver package to use.";
    };

    mountPoint = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = lib.mkDoc ''
        The mount point for the onedriver service. If this directory does
        not exist, it will be created.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.onedriver = {
      Unit = {
        Description = "Onedriver sync service";
      };

      Service = {
        Type = "simple";
        ExecStart = ''
          mkdir -p ${cfg.mountPoint} && \
          ${cfg.package}/bin/onedriver
        '';
        Restart = "on-failure";
        RestartSec = 3;
        RestartPreventExitStatus = 3;
      };
    };
  };
}
