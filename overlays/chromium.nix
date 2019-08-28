self: super: {
  chromium = self.callPackage ./chromium (super.config.chromium or {});
}
