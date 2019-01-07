{ config, pkgs, ... }:
{
  imports = [
    # I'd like to set this up everywhere but it broke and time is limited
    ./dnscrypt.nix
  ];

  networking = {
    # For John von Neumann, of the von Neumann machine etc etc etc
    hostName = "neumann";
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
