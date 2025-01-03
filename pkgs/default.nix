{ pkgs, inputs, ... }:

let
  plugins = {
    # To get a hash run:
    # nix-prefetch-url --unpack https://downloads.wordpress.org/plugins/<name>.<version>.zip
    classic-editor = {
      version = "1.6.7";
      sha256 = "0fs60rdkbddijxga1zn7vlpcmnmvwrdgfvn0wm6y4cxg2cqn1987";
    };
    column-shortcodes = {
      version = "1.0.1";
      sha256 = "04bsr02iazj2indwdg6nrjn9dszknvci39899kz0g3kbn4wgv2f3";
    };
    simple-csv-tables = {
      version = "1.0.3";
      url = "https://downloads.wordpress.org/plugins/simple-csv-tables.zip";
      sha256 = "0aghic2mxljbwir35rvgbz3s0zwys4844svjnmlpad2l8viwvabf";
    };
    youtube-embed-plus = {
      version = "14.2.1.3";
      sha256 = "13wzxnp3wkw3p2nrqbjqvd9qn4g9dfzpmfzxps80sz2ljj214ar6";
    };
    wpdatatables = {
      version = "3.4.2.35";
      sha256 = "1h5iv3wz0l8a9h091yia3syhl0nsb77xpldi8cnvb82ica5wfmxr";
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
