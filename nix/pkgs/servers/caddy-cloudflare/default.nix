{ buildGoModule }:

buildGoModule {
  pname = "caddy-cloudflare";
  version = "v2.8.4";
  src = ./.;
  vendorHash = "sha256-dEuxEG6mW2V7iuSXvziR82bmF+Hwe6ePCfdNj5t3t4c=";
  meta.mainProgram = "caddy";
}
