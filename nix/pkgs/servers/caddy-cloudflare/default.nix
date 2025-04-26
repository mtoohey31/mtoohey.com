{ buildGoModule }:

buildGoModule {
  pname = "caddy-cloudflare";
  version = "v2.9.1";
  src = ./.;
  vendorHash = "sha256-x/6nDUO8h0KLWpNfWdGd9MYcHV2ZZjONWds8+Jc9Nxc=";
  meta.mainProgram = "caddy";
}
