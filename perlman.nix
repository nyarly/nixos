{ config, lib, pkgs, ... }:
{
  # For Radia Perlman, inventor of STP
  networking = {
    hostName = "perlman";
    extraHosts = "127.0.0.1 perlman";
  };
  boot.initrd = {
    luks.devices = [
      # { name = "swap"; device = "/dev/disk/by-uuid/8d951355-45ee-4643-b7a6-4c2e966e5942"; } 
      { name = "lvm";  device = "/dev/disk/by-uuid/b08be164-c886-47e1-9ada-757ba4b44b6c"; preLVM = true; }
    ];
    postMountCommands = "cryptsetup luksOpen --key-file /mnt-root/etc/swap.keyfile /dev/sda2 swap";
  };
  
  services.xserver.videoDrivers = [ "nouveau" "intel"  "modesetting" ];
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
  };

  services.illum.enable = true;

  nixpkgs.overlays = [
    (self: super: {
      pulseaudioFull = super.pulseaudioFull.override {
        x11Support = true;
	bluetoothSupport = true;
      };
    })
  ];
}
