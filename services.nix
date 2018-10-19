{ config, pkgs, lib, ... }:
let
  localDnscryptPort = 43;
  localDnscryptAddress = "127.0.0.1:${toString localDnscryptPort}";
in
{

  imports = [ ./dnscrypt-proxy2.nix ];

  systemd.tmpfiles.rules = [
    "d /tmp 1777 root root 3d"
    ];


  # in preference of GPG Agent
  programs.ssh.startAgent = false;

  virtualisation.virtualbox.host.enable = true;

  nix = {
    gc.automatic = true;
  };

  nixpkgs.overlays = [
    (import overlays/add-dnscrypt-proxy2.nix)
  ];

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      config = {
        listen_addresses = [
          localDnscryptAddress
        ];

        fallback_resolver = "1.1.1.1:53";
        ignore_system_dns = true;

        # Translated from default config
        max_clients = 250;
        ipv4_servers = true;
        ipv6_servers = false;
        dnscrypt_servers = true;
        doh_servers = true;
        require_dnssec = false;
        require_nolog = true;
        require_nofilter = true;
        force_tcp = false;
        timeout = 2500;
        keepalive = 30;
        cert_refresh_delay = 240;
        netprobe_timeout = 30;
        log_files_max_size = 10;
        log_files_max_age = 7;
        log_files_max_backups = 1;
        block_ipv6 = false;
        cache = true;
        cache_size = 512;
        cache_min_ttl = 600;
        cache_max_ttl = 86400;
        cache_neg_min_ttl = 60;
        cache_neg_max_ttl = 600;
        query_log = {
          format = "tsv";
        };
        nx_log = {
          format = "tsv";
        };
        sources = {
          public-resolvers = {
            urls = [
              "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v2/public-resolvers.md"
              "https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md"
            ];
            cache_file = "public-resolvers.md";
            minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
            refresh_delay = 72;
            prefix = "";
          };
        };
      };
    };

    dnsmasq = {
      enable = true;
      servers = [
        "127.0.0.1#${toString localDnscryptPort}"
        "/qasql.opentable.com/10.0.0.104"
        "/qasql.opentable.com/10.0.0.104"
        "/otcorp.opentable.com/10.0.0.103"
        "/otcorp.opentable.com/10.0.0.103"
        #"8.8.8.8"
      ];
      extraConfig = ''
        listen-address=127.0.0.1
        listen-address=127.0.0.42
        log-queries

        address=/local/127.0.0.1
      '';
    };

    xserver = {
      enable = true;
      exportConfiguration = true;

      displayManager.sddm = {
        enable = true;
        autoNumlock = true;
      };
      windowManager = {
        i3.enable = true;
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = haskell: [
            haskell.taffybar
          ];
        };
        default = "xmonad";
      };
      libinput.middleEmulation = true;
      xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";

      # videoDrivers = [] # consider adding nvidia, or examining bumble or whatevs
      multitouch = {
        enable = true;
        ignorePalm = true;
        tapButtons = false;
        additionalOptions = ''
          Option "ScrollDistance" "50"
        '';
      };
      synaptics = {
        enable = true;
        twoFingerScroll = true;
        palmDetect = true;
      };
    };

    /*
    # The Profile Sync Daemon
    psd = {
    enable = true;
    users = [ "judson" ];
    resyncTimer = "30min";
    };
    */

    illum.enable = true;

    # Name Service Cache Daemon
    nscd.enable = true;

    upower.enable = true;

    printing = {
      enable = true;
    };

    # Smartcards
    pcscd.enable = true;

    locate = {
      enable = true;
      localuser = null;
      # the default findutils is torturous
      locate = (lib.hiPrio pkgs.mlocate);
    };

    postgresql = {
      enable = true;
      authentication = ''
        local all all              trust
        host  all all 127.0.0.1/32 trust
        host  all all ::1/128      trust
      '';

    };

    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", MODE="0664", GROUP="wheel"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ACTION=="remove", RUN+="/run/current-system/sw/bin/loginctl lock-sessions"
    '';
  };
}
