{ config, pkgs, lib, ... }:
{
  systemd.tmpfiles.rules = [
    "d /tmp 1777 root root 3d"
    "x /tmp/.org.chromium.Chromium.*"
    ];


  # in preference of GPG Agent
  programs.ssh.startAgent = false;

  virtualisation.virtualbox.host.enable = true;

  nix = {
    gc.automatic = true;

    envVars = {
      NIX_GITHUB_PRIVATE_USERNAME = import ./environment/github-username.private;
      NIX_GITHUB_PRIVATE_PASSWORD = import ./environment/github-token.private;
    };
  };

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
        default = "xmonad";
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

    illum.enable = true;

    # Name Service Cache Daemon
    nscd.enable = true;

    upower.enable = true;

    printing = {
      enable = true;
      #logLevel = "debug";
    };

    # Smartcards
    pcscd.enable = true;

    locate = {
      enable = true;
      localuser = null;
      # the default findutils is torturous
      locate = (lib.hiPrio pkgs.mlocate);
    };

    postgresql = {
      enable = true;
      authentication = ''
        local all all              trust
        host  all all 127.0.0.1/32 trust
        host  all all ::1/128      trust
      '';

    };

    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", MODE="0664", GROUP="wheel"
      SUBSYSTEM=="input", ENV{ID_VENDOR_ID}=="1050", ACTION=="remove", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    '';
  };
}
