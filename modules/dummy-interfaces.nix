{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.networking;

  addrOpts = v:
    assert v == 4 || v == 6;
    { options = {
        address = mkOption {
          type = types.str;
          description = ''
            IPv${toString v} address of the interface. Leave empty to configure the
            interface using DHCP.
          '';
        };

        prefixLength = mkOption {
          type = types.addCheck types.int (n: n >= 0 && n <= (if v == 4 then 32 else 128));
          description = ''
            Subnet mask of the interface, specified as the number of
            bits in the prefix (<literal>${if v == 4 then "24" else "64"}</literal>).
          '';
        };
      };
    };
in
{
  options = {
    networking.dummy-interfaces = mkOption {
      default = { };
      type = with types; attrsOf (submodule (addrOpts 4));
    };
  };

  config = {
    systemd.services =
    let
      createDummyDevice = n: v: nameValuePair
      "${n}-netdev"
      {
        description = "Dummy network interface ${n}";
        wantedBy = [ "network-setup.service" ];
        partOf = [ "network-setup.service" ];
        after = [ "network-pre.target" ];
        before = [ "network-setup.service" ];
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        path = [ pkgs.iproute ];
        script = ''
          # Remove Dead Interfaces
          ip link show "${n}" >/dev/null 2>&1 && ip link delete "${n}"
          ip link add "${n}" type dummy
          ip addr add "${v.address}/${toString v.prefixLength}" dev "${n}"
          ip link set "${n}" up
        '';
        postStop = ''
          ip link delete "${n}" || true
        '';
      };
    in
      mapAttrs' createDummyDevice cfg.dummy-interfaces;
    };
  }
