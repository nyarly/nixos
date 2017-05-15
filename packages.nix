{ config, pkgs, ... }:
{
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
    vcsh

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
    rxvt_unicode
    trayer
    urxvt_perls
    xautolock
    xlsfonts
    xsel

    # Firmware tools
    avrdude
    avrgcclibc
    dfu-util
    usbutils

    # System management
    linuxPackages.bcc
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