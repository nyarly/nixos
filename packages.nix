{ config, pkgs, ... }:
{

  nixpkgs.overlays = [
    (import overlays/bcc.nix)
  ];

  environment.systemPackages = with pkgs; [
    # Basic user environment
    bc
    chromium
    fish
    git
    neovim
    tmux
    tree
    which
    # vcsh # build broken temporarily - using nixpkgs version in user profile

    # Extra nix tools
    nix-repl
    nox
    patchelf

    # Basic X tools
    arandr
    dmenu
    dunst
    i3lock
    i3status
    libnotify
    networkmanagerapplet
    pavucontrol
    blueman
    rxvt_unicode-with-plugins
    trayer
    xautolock
    xlsfonts
    xsel

    # Firmware tools
    avrdude
    avrgcclibc
    dfu-util
    usbutils

    # System management
    #linuxPackages.bcc
    bcc
    bind
    btrfs-progs
    bzip2
    gzip
    htop
    iotop
    openconnect
    unzip

    # Programming
    gnumake
    go
    ruby
    rustc
    cargo

    # Security
    gnupg
    pinentry
    opensc
  ];
}
