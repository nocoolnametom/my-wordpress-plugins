{ pkgs, inputs, ... }:

let
  plugins = {
    # To get a hash run:
    # nix-prefetch-url --unpack https://downloads.wordpress.org/plugins/<name>.<version>.zip
    classic-editor = {
      version = "1.7.0";
      sha256 = "0vhrglvs6q7wnkph88gy388sbja3904740blm2ipli5ddy4fmk15";
    };
    column-shortcodes = {
      # Abandoned
      version = "1.0.1";
      sha256 = "04bsr02iazj2indwdg6nrjn9dszknvci39899kz0g3kbn4wgv2f3";
    };
    simple-csv-tables = {
      # Abandoned
      version = "1.0.3";
      url = "https://downloads.wordpress.org/plugins/simple-csv-tables.zip";
      sha256 = "0aghic2mxljbwir35rvgbz3s0zwys4844svjnmlpad2l8viwvabf";
    };
    youtube-embed-plus = {
      version = "14.2.6";
      sha256 = "0715ma73m6wv2g7v3ny2v0zkzign9rrmn0fg6bw23m4lizw3sfcw";
    };
    wpdatatables = {
      version = "6.5.1.3";
      sha256 = "1drnss9l8pvq36g5a0x03w4qg89cxgmg394yjmhigmygf6syw87m";
    };
  };
  mkPlugin =
    pluginName:
    {
      version,
      sha256,
      url ? "https://downloads.wordpress.org/plugins/${pluginName}.${version}.zip",
    }:
    pkgs.stdenvNoCC.mkDerivation rec {
      inherit pluginName version;
      name = "wp-plugin-${pluginName}";
      src = pkgs.fetchzip {
        inherit sha256 url;
      };
      installPhase = "mkdir -p $out; cp -R * $out/";
    };
in
pkgs.lib.mapAttrs (name: buildInfo: mkPlugin name buildInfo) plugins
// rec {
  wp-theme-twentyten-ken = pkgs.callPackage ./wp-theme-twentyten-ken {
    inherit (inputs) wp-main;
  };
}
