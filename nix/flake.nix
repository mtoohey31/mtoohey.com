{
  description = "mtoohey.com";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: {
    overlays.default = final: prev: {
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
      inherit (pkgs) caddy go hugo mkShell nodePackages nodejs
        prettier-plugin-go-template;
      inherit (nodePackages) cspell diagnostic-languageserver prettier
        typescript-language-server;
    in
    {
      packages.default = pkgs."mtoohey.com";

      devShells.default = mkShell {
        packages = [
          caddy
          cspell
          diagnostic-languageserver
          go
          (hugo.overrideAttrs (oldAttrs: {
            patches = (oldAttrs.patches or [ ]) ++ [
              # TODO: Look into a full fix for this. Looks like all we have to
              # do in this case is save the hugo.toml file.
              ./patches/0001-Vendor-mountless-modules.patch
            ];
          }))
          nodejs
          prettier
          prettier-plugin-go-template
          typescript-language-server
        ];
      };
    });
}
