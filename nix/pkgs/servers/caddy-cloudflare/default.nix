{ buildGoModule }:

buildGoModule {
  pname = "caddy-cloudflare";
  version = "v2.9.1";
  src = ./.;
  vendorHash = "sha256-Z8jdMpa4BSR9zAblHM5SNDZkyw0RlEBzvK1thMtrZl8=";
  meta.mainProgram = "caddy";
}
