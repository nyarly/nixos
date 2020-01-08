{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    # Basic user environment
    aspell
    aspellDicts.en
    bc
    chromium
    exa
    # fish # until stable lands PR
    (fish.overrideAttrs (oldAttrs: { cmakeFlags = []; }))

    manpages
    neovim
    pinfo
    ripgrep
    tmux
    tree
    which

    # version control
    gitFull

    # Extra nix tools
    patchelf

    # Firmware tools
    avrdude
    # Unsuported platform?
    # avrlibc
    # avrbinutils 19.03
    # avrgcc
    dfu-util
    usbutils
    teensy-loader-cli

    # System management
    linuxPackages.bcc
    bind
    btrfs-progs
    bzip2
    gzip
    htop
    hwinfo
    iotop
    lshw
    mtr
    nmap
    openconnect
    pciutils
    psmisc
    unzip
    dbus-map
    # ec2_ami_tools # unfree Amazon license
    duply
    lsof
    mmv
    nethogs
    networkmanager_openconnect
    #libsForQt59.networkmanager-qt
    sysstat
    vagrant
    whois
    wireshark-qt

    openjdk

    # Programming
    man-db
    man-pages
    libxml2

    # Security
    gnupg
    opensc
    openssl
    pinentry
    yubikey-manager
    yubikey-personalization
    yubikey-personalization-gui
    pcsctools

    # Consider extraction to "gui.nix"

    # Basic X tools
    arandr
    blueman
    i3lock
    i3status
    libnotify
    networkmanagerapplet
    pavucontrol
    alacritty
    xautolock
    xss-lock
    xorg.xev
    xlsfonts
    xorg.xkill
    xclip
    primus
    glxinfo
    zoom-us #ick but needed sometimes

  ];
}
