{ buildGoModule }:

buildGoModule {
  pname = "caddy-cloudflare";
  version = "2.7.6";
  src = ./.;
  vendorHash = "sha256-aBJUUC+k3EIRqOtr59k82g/gXXvnQo5NV/QGMuiiK+w=";
  meta.mainProgram = "caddy";
}
