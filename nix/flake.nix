{
  description = "mtoohey.com";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: rec {
    nixosModules.default = { config, lib, pkgs, ... }: {
      options.services."mtoohey.com".enable = lib.mkEnableOption "mtoohey.com";

      config = lib.mkIf config.services."mtoohey.com".enable {
        networking.firewall.allowedTCPPorts = [ 443 ];
        nixpkgs.overlays = [ self.overlays.default ];
        services.caddy = {
          enable = true;
          configFile = pkgs.writeTextFile {
            name = "Caddyfile";
            text = builtins.replaceStrings [ "@extra-global-config@" ]
              [ config.sops.secrets.mtoohey_caddy_extra_global_config.path ]
              (builtins.readFile ../share/Caddyfile);
          };
          package = pkgs.caddy-cloudflare;
        };
        sops.secrets.mtoohey_caddy_extra_global_config = {
          owner = config.services.caddy.user;
          inherit (config.services.caddy) group;
        };
        systemd.services.caddy = {
          environment.MTOOHEY_HTML_ROOT =
            pkgs."mtoohey.com" + "/share/mtoohey.com/html";
          serviceConfig = {
            AmbientCapabilities = "CAP_NET_BIND_SERVICE";
            CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
          };
        };
      };
    };
    nixosModules."mtoohey.com" = nixosModules.default;

    overlays.default = final: prev: {
      caddy-cloudflare = final.callPackage ./pkgs/servers/caddy-cloudflare { };

      "mtoohey.com" = final.stdenv.mkDerivation {
        pname = "mtoohey.com";
        version = "0.1.0";
        src = builtins.path { path = ./..; name = "mtoohey.com-src"; };
        buildInputs = [ final.hugo ];
        buildPhase = ''
          hugo -d $out/share/mtoohey.com/html
        '';
      };
    };
  } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        overlays = [ self.overlays.default ];
        inherit system;
      };
      inherit (pkgs) caddy go hugo mkShell nodePackages nodejs;
      inherit (nodePackages) cspell diagnostic-languageserver prettier
        typescript-language-server;
      prettier-plugin-go-template = (
        pkgs.callPackage ./pkgs/development/node-packages { }
      )."prettier-plugin-go-template-0.0.15";
    in
    {
      packages = {
        default = pkgs."mtoohey.com";
        inherit (pkgs) caddy-cloudflare;
      };

      devShells.default = mkShell {
        packages = [
          caddy
          cspell
          diagnostic-languageserver
          go
          (hugo.overrideAttrs (oldAttrs: {
            patches = (oldAttrs.patches or [ ]) ++ [
              # TODO: Look into a full fix for this. Looks like all we have to
              # do in this case is save the hugo.toml file.
              ./patches/0001-Vendor-mountless-modules.patch
            ];
          }))
          nodejs
          prettier
          prettier-plugin-go-template
          typescript-language-server
        ];
      };
    });
}
