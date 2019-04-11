{ config, pkgs, lib, ... }:
let
  glew20 = pkgs.glew.overrideDerivation (attrs: rec {
    name = "glew-2.0.0";
    src = pkgs.fetchurl {
      url = "mirror://sourceforge/glew/${name}.tgz";
      sha256 = "0r37fg2s1f0jrvwh6c8cz5x6v4wqmhq42qm15cs9qs349q5c6wn5";
    };
  });

  my-steam = pkgs.steam.override {
    withJava = true;
    extraPkgs = with pkgs; originalPkgs: [
      mono5
      gtk3
      gtk3-x11
      libgdiplus
      zlib
      strace
      at-spi2-atk
      pango
      libpng
      fmodex
      glew20
    ];
    nativeOnly = false;
  };
in
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
    teensy-loader-cli

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
    i3lock
    i3status
    keynav
    libnotify
    networkmanagerapplet
    pavucontrol
    alacritty
    trayer
    xautolock
    xss-lock
    xorg.xev
    xlsfonts
    xorg.xkill
    xclip
    gnome3.dconf
    gnome3.dconf-editor

    # Less basic X programs
    my-steam
    my-steam.run
    fontforge
    graphviz
    gimp
    meld
    nitrogen
    pidgin
    shutter
    scrot
    solvespace
    taffybar
    glxinfo
    primus
    vlc
    gnugo
    inkscape
    #zoom-us #ick but needed sometimes
  ];
}
