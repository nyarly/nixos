{ config, pkgs, ... }:
{
  networking = {
    # For John von Neumann, of the von Neumann machine etc etc etc
    hostName = "neumann";
    networkmanager = {
      insertNameservers = [ "127.0.0.42" ];
      useDnsmasq = true;
    };
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
  };

  nixpkgs.overlays = [
    (self: super: {
      pulseaudioFull = super.pulseaudioFull.override {
        x11Support = true;
        bluetoothSupport = true;
      };
    })
  ];

  zramSwap.enable = true;
  services = {
    xserver = {
      videoDrivers = [ "nv" "nouveau" "intel"  "modesetting" ];
    };
  };
}
