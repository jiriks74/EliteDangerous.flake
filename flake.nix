{
  description = "EDMarketConnector";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    EDMarketConnector-src = {
      url = "github:EDCD/EDMarketConnector?ref=Release/5.12.2";
      flake = false;
    };
    pyproject-nix = {
      url = "github:nix-community/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # min-er-launcher = {
    #   url = "github:rfvgyhn/min-ed-launcher?ref=v0.11.2";
    #   flake = false;
    # };
  };

  outputs = {
    nixpkgs,
    EDMarketConnector-src,
    pyproject-nix,
    self,
    ...
  }: let
    inherit (nixpkgs) lib;

    EDMarketConnector = pyproject-nix.lib.project.loadRequirementsTxt {projectRoot = EDMarketConnector-src;};

    # This example is only using x86_64-linux
    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    python = pkgs.python3Full;
  in {
    formatter.x86_64-linux = pkgs.alejandra;
    # Build our package using `buildPythonPackage`
    packages.x86_64-linux = {
      EDMarketConnector = let
        pythonEnv = python.withPackages (
          EDMarketConnector.renderers.withPackages {inherit python;}
        );
      in
        pkgs.writeShellScriptBin "EDMarketConnector" ''
          exec ${pythonEnv}/bin/python ${self}/EDMarketConnector.py "$@"
        '';
    };
    min-ed-launcher = pkgs.callPackage ./min-ed-launcher.nix {};
  };
}
