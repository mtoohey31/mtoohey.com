{ buildGoModule }:

buildGoModule {
  pname = "caddy-cloudflare";
  version = "v2.9.1";
  src = ./.;
  vendorHash = "sha256-fZuNsr++p0Se7yYfjeKCsU11cE+JvO6W35HzQ3bTn7Q=";
  meta.mainProgram = "caddy";
}
