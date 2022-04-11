{
  description = "mtoohey.com";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; {
        devShell = mkShell { nativeBuildInputs = [ nodePackages.pnpm wrangler nodePackages.npm nodejs ]; };
      });
}
