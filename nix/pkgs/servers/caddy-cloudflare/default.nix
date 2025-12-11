{ buildGoModule }:

buildGoModule {
  pname = "caddy-cloudflare";
  version = "v2.10.2";
  src = ./.;
  vendorHash = "sha256-ix+W0+/SWHpRlA+qJftu17TEPI/yqF2N/GDYjGpiiNA=";
  meta.mainProgram = "caddy";
}
