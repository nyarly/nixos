# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      networkmanager_openconnect = pkgs.networkmanager_openconnect.override {
        openconnect = pkgs.openconnect_gnutls;
      };
    };
  };

  boot = {
    # Need 4.6 for offcpuflamegraph
    kernelPackages = pkgs.linuxPackages_4_9;

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

  networking.hostName = "neumann";
  networking.extraHosts = ''
  10.254.134.35 virtualvx.hautelook.net
  '';

  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  programs.ssh.startAgent = false;

  # List services that you want to enable:

  services = {
    # probably should reset this
    journald.rateLimitInterval = "0";
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
	    haskell.xmobar
	  ];
	};
	default = "i3";
      };
      libinput.middleEmulation = true;
      xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
# videoDrivers = [] # consider adding nvidia, or examining bumble or whatevs
      multitouch = {
	enable = true;
	ignorePalm = true;
      };
      synaptics = {
	enable = true;
	twoFingerScroll = true;
	palmDetect = true;
      };
    };

    printing = {
      enable = true;
    };

    postgresql = {
      enable = true;
      enableTCPIP = true;
    };
/*
    psd = {
      enable = true;
      users = [ "judson" ];
      resyncTimer = "30min";
    };

    clamav = {
      updater.enable = true;
      daemon.enable = true;
    };
*/

    pcscd.enable = true;
    locate = {
      enable = true;
      localuser = "root";
    };

    upower.enable = true;


    udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="wheel", ATTRS{idVendor}=="1050"
    '';
  };

  environment.systemPackages = with pkgs; [
    # Basic user environment
    bc
    chromium
    fish
    git
    neovim
    tmux
    tree
    which

    # Extra nix tools
    nix-repl
    nox
    patchelf

    # Basic X tools
    arandr
    dmenu
    dunst
    i3lock
    i3status
    libnotify
    networkmanagerapplet
    pavucontrol
    rxvt_unicode
    trayer
    urxvt_perls
    xautolock
    xlsfonts
    xsel

    # Firmware tools
    avrdude
    avrgcclibc
    dfu-util
    usbutils

    # System management
    #bcc # someday...
    linuxPackages.bcc
    bind
    btrfs-progs
    bzip2
    gzip
    htop
    iotop
    openconnect
    unzip

    # Programming
    gnumake
    go
    ruby
    rustc
    cargo

    # Security
    gnupg
    pinentry
    opensc
  ];

  powerManagement.enable = true;
  security.sudo.wheelNeedsPassword = false;
  sound.mediaKeys.enable = true;

  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    opengl.driSupport32Bit = true;
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.judson = {
    isNormalUser = true;
    uid = 1000;
    shell = "/run/current-system/sw/bin/fish";
    extraGroups = [ "wheel" "audio" "networkmanager" "docker" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

}
