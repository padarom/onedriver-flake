{
  description = "A flake for Jeff Stafford's Onedriver";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    onedriver-src = {
      url = "github:jstaf/onedriver";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, onedriver-src, ... } @ inputs:
    {
      overlays.default = (final: prev: {
        onedriver = self.packages.${prev.stdenv.hostPlatform.system}.default;
      });

      nixosModules = rec {
        onedriver = import ./modules/onedriver-module.nix;
        default = onedriver;
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.callPackage ./pkgs/onedriver {
          inherit pkgs onedriver-src;
        };
      }
    );
}
