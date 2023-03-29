{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.onedriver;
in {
  options.services.onedriver = {
    enable = mkEnableOption (mdDoc "A native Linux filesystem for Microsoft OneDrive");

    package = mkOption {
      type = types.package;
      default = pkgs.onedriver;
      defaultText = "pkgs.onedriver";
      description = "Which onedriver package to use.";
    };

    mountPoint = mkOption {
      type = types.nonEmptyStr;
      description = mkDoc ''
        The mount point for the onedriver service. If this directory does
        not exist, it will be created.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services."onedriver@" = {
      enable = true;
      serviceConfig = {
        ExecStart = ''
          mkdir -p ${cfg.mountPoint} && \
          ${cfg.package}/bin/onedriver
        '';
        Restart = "on-failure";
        RestartSec = 3;
        RestartPreventExitStatus = 3;
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
