{ config, lib, pkgs, ... }:
{
  # For Radia Perlman, inventor of STP
  networking = {
    hostName = "perlman";
    extraHosts = ''
      127.0.0.1 perlman

      104.236.209.43 ha.pool.sks-keyservers.net
      208.113.128.181 ha.pool.sks-keyservers.net
      79.143.214.213 ha.pool.sks-keyservers.net
      178.32.66.144 ha.pool.sks-keyservers.net
      67.205.155.18 ha.pool.sks-keyservers.net
    '';

  };
  boot.initrd = {
    luks.devices = [
      { name = "lvm";  device = "/dev/disk/by-uuid/b08be164-c886-47e1-9ada-757ba4b44b6c"; preLVM = true; }
    ];
    postMountCommands = "cryptsetup luksOpen --key-file /mnt-root/etc/swap.keyfile /dev/sda2 swap";
  };

  services = {
    illum.enable = true;

    xserver = {
      videoDrivers = [ "nouveau" "intel"  "modesetting" ];
      multitouch = {
        enable = true;
        ignorePalm = true;
        tapButtons = false;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  /*
  hardware.bumblebee = {
  enable = true;
  connectDisplay = true;
  };
  */

  hardware = {
    bluetooth.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
    trackpoint = {
      enable = true;
      emulateWheel = true;
      # fakeButtons = true;
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      pulseaudioFull = super.pulseaudioFull.override {
        x11Support = true;
        bluetoothSupport = true;
      };
    })
  ];
}
