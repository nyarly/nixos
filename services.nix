{ config, pkgs, lib, ... }:
{

  systemd.tmpfiles.rules = [
    "d /tmp 1777 root root 3d"
    ];


  # in preference of GPG Agent
  programs.ssh.startAgent = false;

  virtualisation.virtualbox.host.enable = true;

  nix.gc.automatic = true;

  services = {
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
        tapButtons = false;
        additionalOptions = ''
          Option "ScrollDistance" "50"
        '';
      };
      synaptics = {
        enable = true;
        twoFingerScroll = true;
        palmDetect = true;
      };
    };

    /*
    # The Profile Sync Daemon
    psd = {
    enable = true;
    users = [ "judson" ];
    resyncTimer = "30min";
    };
    */

    illum.enable = true;

    # Name Service Cache Daemon
    nscd.enable = true;

    upower.enable = true;

    printing = {
      enable = true;
    };

    clamav = {
      updater.enable = true;
      daemon.enable = true;
    };

    # Smartcards
    pcscd.enable = true;

    locate = {
      enable = true;
      localuser = null;
      # the default findutils is torturous
      locate = (lib.hiPrio pkgs.mlocate);
    };

    postgresql.enable = true;

    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", MODE="0664", GROUP="wheel"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ACTION=="remove", RUN+="/run/current-system/sw/bin/loginctl lock-sessions"
    '';
  };
}
