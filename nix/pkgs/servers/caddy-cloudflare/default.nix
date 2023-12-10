{ buildGoModule }:

buildGoModule {
  pname = "caddy-cloudflare";
  version = "2.7.6";
  src = ./.;
  vendorHash = "sha256-EiDxMJOiARcytCOfLAPC/uSZsXCVzUSszHxr+bbq0gY=";
}
