{ config, pkgs, ... }:
{
  # For John von Neumann, of the von Neumann machine etc etc etc
  networking.hostName = "neumann";

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
