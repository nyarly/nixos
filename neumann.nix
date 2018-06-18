{ config, pkgs, ... }:
{
  networking.hostName = "neumann";

  zramSwap.enable = true;
  services = {
    xserver = {
      videoDrivers = [ "nv" "nouveau" "intel"  "modesetting" ];
    };
  };
}
