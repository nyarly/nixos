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
    exa
    fasd
    fish
    fzf
    kakoune
    manpages
    neovim
    pinfo
    qrencode
    ranger
    ripgrep
    tmux
    tree
    vcsh
    which


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

    #2nix
    go2nix
    npm2nix
    pypi2nix
    bundix


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
    kafkacat
    maven
    cargo
    rustc
    rustfmt
    teensy-loader-cli
    universal-ctags
    kona
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
    dmenu
    dunst
    feh
    illum
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
    graphviz
    gimp
    meld
    nitrogen
    pidgin
    shutter
    scrot
    solvespace
    signal-desktop
    #  steam
    taffybar #huge memory leak?
    polybar
    glxinfo
    primus
    vlc
    gnugo
    inkscape
    zoom-us


  ];
}
