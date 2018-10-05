{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs) pulseaudioFull;

  cfg = config.services.reloadBluetooth;
in
{
  options = {
    services.reloadBluetooth = {
      enable = mkOption {
        default = false;
        description = ''
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.reloadBluetooth = {
      description = "reload bluetooth modules on resume";

      after = [ "suspend.target" ];

      wantedBy = [ "suspend.target" ];

      serviceConfig = {
        Type = "oneshot";
        Restart = "no";
      };

      script = with cfg; ''
        ${pulseaudioFull}/bin/pactl unload-module module-bluetooth-policy
        ${pulseaudioFull}/bin/pactl unload-module module-bluetooth-discover
        ${pulseaudioFull}/bin/pactl load-module module-bluetooth-policy
        ${pulseaudioFull}/bin/pactl load-module module-bluetooth-discover
      '';
    };
  };
}
