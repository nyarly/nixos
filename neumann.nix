{ config, pkgs, ... }:
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
      binutils #addr2line for stacktraces
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
      inetutils # Unrailed expects ping...
    ];
    nativeOnly = false;
  };
in
{
  imports = [
    # I'd like to set this up everywhere but it broke and time is limited
    ./dnscrypt.nix
  ];

  environment.systemPackages = with pkgs; [
    /*
    my-steam
    my-steam.run
    */
    steam
    steam.run
  ];

  networking = {
    # For John von Neumann, of the von Neumann machine etc etc etc
    hostName = "neumann";
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
  };

  nixpkgs.overlays = [
    (self: super: {
      pulseaudioFull = super.pulseaudioFull.override {
        x11Support = true;
        bluetoothSupport = true;
      };
    })
  ];

  zramSwap.enable = true;
  services = {
    xserver = {
      videoDrivers = [ "nv" "nouveau" "intel"  "modesetting" ];
    };

    printing = {
      enable = true;
      drivers = with pkgs; [
        brlaser
        cups-brother-hl1110
        gutenprint
        #mfcl8690cdwlpr
      ];
    };
  };
}
