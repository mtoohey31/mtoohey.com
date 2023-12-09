{
  description = "mtoohey.com";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: {
    overlays.default = final: prev: {
      hugo = prev.hugo.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          ./patches/0001-Vendor-mountless-modules.patch
        ];
      });

      "mtoohey.com" = final.stdenv.mkDerivation {
        pname = "mtoohey.com";
        version = "0.1.0";
        src = builtins.path { path = ./..; name = "mtoohey.com-src"; };
        buildInputs = [ final.git final.go final.hugo ];
        buildPhase = ''
          hugo -d $out/share/mtoohey.com/html
        '';
      };
    };
  } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        overlays = [
          self.overlays.default
          (_: prev: let pkgs = prev; in import ./pkgs pkgs)
        ];
        inherit system;
      };
      inherit (pkgs) go hugo mkShell nodePackages nodejs
        prettier-plugin-go-template;
      inherit (nodePackages) prettier typescript-language-server;
    in
    {
      packages.default = pkgs."mtoohey.com";

      devShells.default = mkShell {
        packages = [
          go
          hugo
          nodejs
          prettier
          prettier-plugin-go-template
          typescript-language-server
        ];
      };
    });
}
