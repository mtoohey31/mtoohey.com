#!/usr/bin/env -S nix shell --ignore-environment --keep GOPATH nixpkgs#xcaddy nixpkgs#bash nixpkgs#coreutils nixpkgs#gnugrep nixpkgs#go --command bash -euo pipefail

{ buildenv=$(
XCADDY_SKIP_BUILD=1 xcaddy build --with github.com/caddy-dns/cloudflare@latest 2>&1 \
  | tee /dev/fd/3 \
  | grep -oP '(?<=\[INFO\] Skipping cleanup as requested; leaving folder intact: ).*'
); } 3>&1
mv "$buildenv"/* .
