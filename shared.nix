{ config, pkgs, ... }:
{
  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      networkmanager_openconnect = pkgs.networkmanager_openconnect.override {
        openconnect = pkgs.openconnect_gnutls;
      };
    };
  };

  boot = {
    # Use the gummiboot efi boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      "vm.swappiness" = 3;
      "vm.vfs_cache_pressure" = 50;
    };
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
  ];

  gtk.iconCache.enable = true; # required for taffybar?

  networking.firewall = {
    pingLimit = "--limit 1/minute --limit-burst 5";
    checkReversePath = "loose"; # experimenting for Kind
    # logReversePathDrops = true; # helpful, but so chatty
    # if loose doesn't work...
    # extraCommands = ''iptables -t raw -I nixos-fw-rpfilter 4 ...'';
  };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  powerManagement.enable = true;
  security.sudo.wheelNeedsPassword = false;
  sound.mediaKeys.enable = true;

  documentation.man.enable = true;

  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
  };

  environment.etc = {
    "systemd/user-generators/polybar-monitors" =
    let gen = pkgs.writeShellScriptBin "polybar-monitors"
    ''
      src="''${HOME}/.config/systemd/user/polybar@.service"
      [ -f "$src" ] || exit 0

      tgt="''${1}/graphical-session.target.wants/"
      mkdir -p $tgt
      for d in $( xrandr -display :0.0 -q | grep '\bconnected\b' | awk '{ print $1 }' ); do
        ln -s "$src" "$tgt/polybar@''${d}.service"
      done
    '';
    in {
      source = "${gen}/bin/polybar-monitors";
      mode = "0555";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.judson = {
    isNormalUser = true;
    uid = 1000;
    shell = "/run/current-system/sw/bin/fish";
    extraGroups = [ "wheel" "audio" "cdrom" "networkmanager" "docker" "vboxusers" "lp" "dialout" ];
  };
}
