# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./shared.nix
    ./neumann.nix
  ];


  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
