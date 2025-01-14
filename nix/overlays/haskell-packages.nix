{ compiler, extraOverrides ? (final: prev: { }) }:

self: super:
let
  inherit (self.haskell) lib;

  overrides =
    final: prev:
    rec {
      # To pin custom versions of Haskell packages:
      #   protolude =
      #     prev.callHackageDirect
      #       {
      #         pkg = "protolude";
      #         ver = "0.3.0";
      #         sha256 = "<sha256>";
      #       }
      #       { };
      #
      # To temporarily pin unreleased versions from GitHub:
      #   <name> =
      #     prev.callCabal2nixWithOptions "<name>" (super.fetchFromGitHub {
      #       owner = "<owner>";
      #       repo  = "<repo>";
      #       rev = "<commit>";
      #       sha256 = "<sha256>";
      #    }) "--subpath=<subpath>" {};
      #
      # To fill in the sha256:
      #   update-nix-fetchgit nix/overlays/haskell-packages.nix

      postgresql-libpq = lib.dontCheck
        (prev.callCabal2nix "postgresql-libpq"
          (super.fetchFromGitHub {
            owner = "PostgREST";
            repo = "postgresql-libpq";
            rev = "890a0a16cf57dd401420fdc6c7d576fb696003bc"; # master
            sha256 = "1wmyhldk0k14y8whp1p4akrkqxf5snh8qsbm7fv5f7kz95nyffd0";
          })
          { });

      hasql-notifications = lib.dontCheck
        (prev.callHackageDirect
          {
            pkg = "hasql-notifications";
            ver = "0.2.0.6";
            sha256 = "sha256-7PyFlB2B70njudOjaX6tk1m77ol9vnF5fI0LF86kVAI=";
          }
          { });

      hasql-pool = lib.dontCheck
        (prev.callHackageDirect
          {
            pkg = "hasql-pool";
            ver = "0.10";
            sha256 = "sha256-kHzoqtNV9BFWnn1h560JRqMooQRwxokVKgDRBexamNI=";
          }
          { });
    } // extraOverrides final prev;
in
{
  haskell =
    super.haskell // {
      packages = super.haskell.packages // {
        "${compiler}" =
          super.haskell.packages."${compiler}".override { inherit overrides; };
      };
    };
}
