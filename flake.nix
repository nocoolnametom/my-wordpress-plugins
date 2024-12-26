{
  description = "The Wordpress Plugins I used for WP Servers";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/release-24.11";
    };

    # Pre-commit hooks
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wordpress Themes and Plugins
    wp-main = {
      url = "github:WordPress/WordPress";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      wp-main,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux" # Most other systems
        "aarch64-linux" # Raspberry Pi 4
        "aarch64-darwin" # Apple Silicon
      ];
      inherit (nixpkgs) lib;
      specialArgs = {
        inherit
          inputs
          outputs
          nixpkgs
          ;
      };
    in
    {
      # Custom packages to be shared or upstreamed.
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs { inherit inputs pkgs; }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./checks { inherit inputs system pkgs; }
      );

      # Nix formatter available through 'nix fmt' https://github.com/NixOS/nixfmt
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
