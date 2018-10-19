{ config, pkgs, ... }:
let
  localDnscryptAddress = "127.0.0.2";
  dockerCompatibilityPrefix = "172.19.17.";
  dockerCompatibilityAddress = "${dockerCompatibilityPrefix}1";
in
{
  imports = [
    ./modules/dummy-interfaces.nix
    ./modules/dnscrypt-proxy2.nix
  ];

  networking = {
    dummy-interfaces = {
      "dns_dummy" = { address = dockerCompatibilityAddress; prefixLength = 24; };
    };
    networkmanager = {
      enable = true;
      insertNameservers = [
        "127.0.0.1"
        dockerCompatibilityAddress
      ];
      #useDnsmasq = true;
    };

    extraResolvconfConf = ''
      unbound_conf=/var/lib/unbound/unbound-resolvconf.conf

    '';
    /*
    extraResolvconfConf = ''
      dnsmasq_conf=/etc/dnsmasq-conf.conf
      dnsmasq_resolv=NO
      dnsmasq_pid=/var/run/dnsmasq.pid
    '';
    */
  };

  services = {
    unbound = {
      enable = true;
      interfaces = [
        dockerCompatibilityAddress
        "127.0.0.1"
        "::1"
      ];

      forwardAddresses = [ localDnscryptAddress ];

      extraConfig = ''
        include: /var/lib/unbound/unbound-resolvconf.conf

        server:
          do-not-query-localhost: no
          pidfile: /var/run/unbound.pid
      '';
    };

    dnsmasq = {
      #enable = true;
      servers = [
        #"127.0.0.1#${toString localDnscryptPort}"
        localDnscryptAddress
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

    dnscrypt-proxy2 = {
      enable = true;
      config = {
        listen_addresses = [
          "${localDnscryptAddress}:53"
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
  };
}
