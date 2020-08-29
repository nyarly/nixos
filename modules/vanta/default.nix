{ stdenv
, fetchurl
, dpkg
, autoPatchelfHook
}:
let
  version = "1.5.9";
  credentials = import ./credentials.nix;
in
stdenv.mkDerivation {
  name = "vanta-${version}";

  src = fetchurl {
    url = "https://vanta-agent.s3.amazonaws.com/v${version}/vanta.deb";
    sha256 = "02gjgrphvifaxnnb7mcla2wm51mjz7dplpjqmb6flphq51znv8nk";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  sourceRoot = ".";
  unpackCmd = ''dpkg-deb -x "$src" .'';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -a etc var $out
    cp -a usr/share/ $out/
    cp usr/lib/systemd/system/vanta.service $out/share/doc/vanta/
  '';
}
