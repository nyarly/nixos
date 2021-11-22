let
  unstableTgz = builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixos-nixos-unstable-2021-11-11";
    # Be sure to update the above if you update the archive
    url = https://github.com/nixos/nixpkgs/archive/715f63411952c86c8f57ab9e3e3cb866a015b5f2.tar.gz;
    sha256 = "152kxfk11mgwg8gx0s1rgykyydfb7s746yfylvbwk5mk5cv4z9nv";
  };
in
import unstableTgz {}
