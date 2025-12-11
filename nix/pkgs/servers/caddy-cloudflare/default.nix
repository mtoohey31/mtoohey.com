{ buildGoModule }:

buildGoModule {
  pname = "caddy-cloudflare";
  version = "v2.10.2";
  src = ./.;
  vendorHash = "sha256-JlD6t078VbovFIB/TQ28dwDQHNT5ekIIR4Avv+OqXOU=";
  meta.mainProgram = "caddy";
}
