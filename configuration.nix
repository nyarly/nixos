# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstableTarball = fetchGit {
    name = "nixos-unstable-2020-03-09";
    url = https://github.com/NixOS/nixpkgs-channels/;
    ref = "refs/heads/nixos-unstable";
    rev = "82b54d490663b6d87b7b34b9cfc0985df8b49c7d";
  };
in
{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./local-configuration.nix
    ./shared.nix
    ./services.nix
    ./packages.nix
    ./modules/reload-bluetooth.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;

    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };


  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";
}
