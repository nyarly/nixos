{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Basic user environment
    aspell
    aspellDicts.en
    bc
    chromium
    direnv
    dynamic-colors
    fasd
    fish
    fzf
    ripgrep
    tmux
    tree
    vcsh
    which
    manpages
    direnv
    exa
    fasd
    fzf
    vcsh
    kakoune
    neovim
    ranger
    qrencode


    # version control
    gitAndTools.tig
    gitAndTools.hub
    gitFull
    pijul

    #manpages.docdev

    # Extra nix tools
    nix-prefetch-scripts
    nox
    patchelf
    nixops

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
    dbus-map
    docker_compose
    # ec2_ami_tools # unfree Amazon license
    duply
    lsof
    mmv
    nethogs
    networkmanager_openconnect
    libsForQt59.networkmanager-qt
    sqlite-interactive
    sysstat
    vagrant
    whois
    wireshark-qt

    # Fonts
    fontforge-fonttools
    fontforge-gtk
    gucharmap

    # Programming
    docker_compose
    fswatch
    git-hub
    git-crypt
    gnumake
    go
    jq
    lldb
    racer
    ruby
    apacheKafka
    kafkacat #still missing?
    maven
    bundix
    cargo
    rustc
    rustfmt
    universal-ctags
    # godep # so deprecated
    kona
    man-db
    man-pages
    visualvm #ugh
    # oraclejdk8psu #nonfree
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
    dmenu
    dunst
    feh
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
    xorg.xev
    xlsfonts
    xorg.xkill
    xclip
    gnome3.dconf
    gnome3.dconf-editor

    # Less basic X programs
    fontforge
    gimp
    meld
    nitrogen
    pidgin
    shutter
    scrot
    solvespace
    #taffybar #huge memory leak
    polybar
    wine # for 1password
    glxinfo
    primus
    vlc
    gnugo
    inkscape
    zoom-us


  ];
}
