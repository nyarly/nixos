self: super:
{
  openresolv = super.openresolv.overrideAttrs ( old: let
    coreutils = super.coreutils.overrideAttrs ( old: rec {
      doCheck = false;
    });
  in
  rec {
    patches = [ ./resolvconf.patch ];

    postInstall = ''
      wrapProgram "$out/sbin/resolvconf" \
      --run "${coreutils}/bin/env >> /tmp/resolvconf.env" \
      --run "${coreutils}/bin/echo \$BASH_COMMAND >> /tmp/resolvconf.bashcommand" \
      --run "${coreutils}/bin/echo \$@ >> /tmp/resolvconf.bashcommand" \
      --set PATH "${coreutils}/bin"
    '';
  });
}
