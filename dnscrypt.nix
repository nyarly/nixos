{ config, pkgs, ... }:
let
  localDnscryptAddress = "127.0.0.2";
  dockerCompatibilityPrefix = "172.37.17.";
  dockerCompatibilityAddress = "${dockerCompatibilityPrefix}1";
in
{
  boot.kernelModules = [ "dummy" ];

  networking = {
    interfaces.dummy0.ipv4.addresses = [
      { address = dockerCompatibilityAddress; prefixLength = 24; }
    ];

    # Have to poke a hole in our firewall for docker containers to reach the DNS server.
    firewall = {
      extraCommands = ''
        iptables -A nixos-fw -i docker0 -d ${dockerCompatibilityAddress} -p udp -m udp --destination-port 53 -j nixos-fw-accept
        iptables -A nixos-fw -i docker0 -s ${dockerCompatibilityAddress} -p udp -m udp --source-port      53 -j nixos-fw-accept
      '';
    };

    resolvconf = {
      extraConfig = ''
        replace search/*/
      '';
    };

    networkmanager = {
      enable = true;
      insertNameservers = [
        "127.0.0.1"
        dockerCompatibilityAddress
      ];
    };
  };

  # Funny story: NetworkManager trips on its own feet trying to get the Openconnect
  # response to resolvconf, which leads to it truncating the list of resolved
  # domains to 6. Fortunately, it provides the right list to dispatcher scripts.
  environment.etc = {
    "NetworkManager/dispatcher.d/vpn-unbound" = {
      source = lib/vpn-unbound;
    };

    "NetworkManager/dispatcher.d/clobber-search" =
    {
      text = ''
        #!/bin/sh
        PATH=${with pkgs; lib.makeBinPath [ gnused ]}
        sed -i '/^search /d' /etc/resolv.conf
      '';
      mode = "0500";
    };
  };

  systemd.services.unbound.preStart = ''
    mkdir -m 0755 -p /var/lib/unbound/dev/
    touch /var/lib/unbound/unbound-resolvconf.conf
    export PATH=$PATH:${pkgs.openssl}/bin
    ${config.services.unbound.package}/bin/unbound-control-setup -d /var/lib/unbound
  '';

  services = {
    unbound = {
      enable = true;

      interfaces = [
        dockerCompatibilityAddress
        "127.0.0.1"
        "::1"
      ];

      forwardAddresses = [ localDnscryptAddress ];

      /*
      infra-host-ttl: 900 #default 900s
      infra-cache-min-rtt: 50 # default 50ms
      */

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
          access-control: 172.17.0.0/16 allow
          val-permissive-mode: yes

          infra-host-ttl: 5 #default 900s
          infra-cache-min-rtt: 500 # default 50ms

        remote-control:
          control-enable: yes
          control-interface: 127.0.0.1
          server-key-file: /var/lib/unbound/unbound_server.key
          server-cert-file: /var/lib/unbound/unbound_server.pem
          control-key-file: /var/lib/unbound/unbound_control.key
          control-cert-file: /var/lib/unbound/unbound_control.pem
      '';
    };

    dnscrypt-proxy2 = {
      enable = true;
      settings = {
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
