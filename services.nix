{ config, pkgs, ... }:
{

  systemd.tmpfiles.rules = [
    "d /tmp 1777 root root 3d"
    ];


  # in preference of GPG Agent
  programs.ssh.startAgent = false;

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
          Option "ScrollDistance" 50
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
      localuser = "root";
    };

    # Default behavior is "HybridSuspend" which would be rad, except that the T460p
    # has a real hard time waking up.
    #upower.enable = true;

    postgresql.enable = true;

    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", MODE="0664", GROUP="wheel"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ACTION=="remove", RUN+="/run/current-system/sw/bin/loginctl lock-sessions"
    '';
  };
}
