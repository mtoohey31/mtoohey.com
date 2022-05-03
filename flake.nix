{
  description = "mtoohey.com";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; {
        devShells.default = mkShell {
          nativeBuildInputs =
            [
              wrangler
              nodejs
            ] ++ (with nodePackages; [
              npm
              pnpm
              prettier
            ]);
        };
      });
}
