{ config, pkgs, ... }:
let
  localDnscryptAddress = "127.0.0.2";
  dockerCompatibilityPrefix = "172.37.17.";
  dockerCompatibilityAddress = "${dockerCompatibilityPrefix}1";
in
{
  imports = [
    #./modules/dummy-interfaces.nix
    ./modules/dnscrypt-proxy2.nix
  ];

  boot.kernelModules = [ "dummy" ];

  networking = {
    interfaces.dummy0.ipv4.addresses = [
      { address = dockerCompatibilityAddress; prefixLength = 24; }
    ];

    firewall = {
      extraCommands = ''
        iptables -A nixos-fw -i docker0 -d ${dockerCompatibilityAddress} -p udp -m udp --destination-port 53 -j nixos-fw-accept
        iptables -A nixos-fw -i docker0 -s ${dockerCompatibilityAddress} -p udp -m udp --source-port      53 -j nixos-fw-accept
      '';
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

          # Traffic to the non localhost interface
          # comes from a DHCP assigned address
          # Ideal case would be to add something to resolvconf
          # or the NetworkManager dispatcher
          access-control: 192.168.0.0/16 allow
          access-control: 10.0.0.0/8 allow
          # oh yeah, docker containers
          access-control: 172.17.0.0/16 allow
          val-permissive-mode: yes

        remote-control:
          control-enable: yes
          control-interface: 127.0.0.1
          server-key-file: /var/lib/unbound/unbound_server.key
          server-cert-file: /var/lib/unbound/unbound_server.pem
          control-key-file: /var/lib/unbound/unbound_control.key
          control-cert-file: /var/lib/unbound/unbound_control.pem

        # Totally a hack until I can figure out how to get VPN working properly.
        forward-zone:
          name: qasql.opentable.com
          forward-addr: 10.0.0.103
          forward-addr: 10.0.0.104

        forward-zone:
          name: otcorp.opentable.com
          forward-addr: 10.0.0.103
          forward-addr: 10.0.0.104
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
