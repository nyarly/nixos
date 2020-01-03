{ config, pkgs, ... }:
{
  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      networkmanager_openconnect = pkgs.networkmanager_openconnect.override {
        openconnect = pkgs.openconnect_gnutls;
      };
    };
  };

  boot = {
    # Use the gummiboot efi boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      "vm.swappiness" = 3;
      "vm.vfs_cache_pressure" = 50;
    };
  };

  environment.systemPackages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
  ];

  networking.firewall = {
    pingLimit = "--limit 1/minute --limit-burst 5";
  };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  powerManagement.enable = true;
  security.sudo.wheelNeedsPassword = false;
  sound.mediaKeys.enable = true;

  documentation.man.enable = true;

  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    opengl.driSupport32Bit = true;
  };

  virtualisation.docker = {
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.judson = {
    isNormalUser = true;
    uid = 1000;
    shell = "/run/current-system/sw/bin/fish";
    extraGroups = [ "wheel" "audio" "cdrom" "networkmanager" "docker" "vboxusers" "lp" "dialout" ];
  };
}
