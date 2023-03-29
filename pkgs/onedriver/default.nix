{ lib, pkgs, buildGoModule, onedriver-src }:
with pkgs;
let
  go = buildGoModule {
    name = "onedriver";
    src = onedriver-src;
    vendorHash = "sha256-OOiiKtKb+BiFkoSBUQQfqm4dMfDW3Is+30Kwcdg8LNA=";
    buildInputs = [ webkitgtk json-glib ];
    nativeBuildInputs = [ pkgs.pkg-config ];
    subPackages = [ "cmd/onedriver" ];
  };
in
stdenv.mkDerivation {
  name = "onedriver";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${go}/bin/onedriver $out/bin
  '';
}
