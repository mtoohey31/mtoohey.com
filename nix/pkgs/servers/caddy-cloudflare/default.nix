{ buildGoModule }:

buildGoModule {
  pname = "caddy-cloudflare";
  version = "v2.8.4";
  src = ./.;
  vendorHash = "sha256-AzrRZi1dGZLVx+1vW+jCNgwq/1YFQU+OaNlMjUj2bI0=";
  meta.mainProgram = "caddy";
}
