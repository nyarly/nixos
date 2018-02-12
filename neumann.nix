{ config, pkgs, ... }:
{
  networking.hostName = "neumann";

  zramSwap.enable = true;
}
