{ config, pkgs, ... }:
{

  nixpkgs.overlays = [
    (import overlays/bcc.nix)
  ];

  environment.systemPackages = with pkgs; [
    # Basic user environment
    bc
    chromium
    direnv
    dynamic-colors
    fasd
    fish
    fzf
    git
    neovim
    ripgrep
    tmux
    tree
    # vcsh # build was broken in NixOS 17.03
    which

    # Extra nix tools
    nix-prefetch-scripts
    nix-repl
    nox
    patchelf

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
    gist
    gzip
    html-tidy
    htop
    hwinfo
    iotop
    nmap
    openconnect
    pciutils
    psmisc
    unzip

    # Programming
    cargo
    docker_compose
    git-hub
    gnumake
    go
    jq
    #kafkacat # not in nixos yet
    lldb
    racer
    ruby
    rustc

    # Security
    gnupg
    opensc
    openssl
    pinentry

    # Consider extraction to "gui.nix"

    # Basic X tools
    arandr
    blueman
    dmenu
    dunst
    i3lock
    i3status
    keynav
    libnotify
    networkmanagerapplet
    pavucontrol
    rxvt_unicode-with-plugins
    trayer
    xautolock
    xlsfonts
    xorg.xkill
    xsel

    # Less basic X programs
    fontforge
    gimp
    meld
    nitrogen
    pidgin
    shutter
    solvespace
    taffybar
    wine # for 1password

  ];
}
