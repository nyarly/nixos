{ config, pkgs, ... }:
{
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

    upower.enable = true;

    postgresql.enable = true;

    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="wheel", ATTRS{idVendor}=="1050"
    '';
  };
}
