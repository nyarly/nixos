{ config, pkgs, ... }:
{

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
    vcsh # build was broken in NixOS 17.03
    which
    manpages
    #manpages.docdev

    # Extra nix tools
    nix-prefetch-scripts
    nix-repl
    nox
    patchelf

    # Firmware tools
    avrdude
    avrbinutils
    avrgcc
    avrlibc
    dfu-util
    usbutils

    # System management
    linuxPackages.bcc
    # bcc
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
    # rustc # doesn't work - need to use the mozilla overlays

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
    alacritty #maybe replacing rxvt?
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
    franz
    wine # for 1password

  ];
}
