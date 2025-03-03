{
  description = "EDMarketConnector";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    nixpkgs,
    ...
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    formatter.x86_64-linux = pkgs.alejandra;
    packages.x86_64-linux = {
      EDMarketConnector = pkgs.callPackage ./pkgs/EDMarketConnector.nix {};
      min-ed-launcher = pkgs.callPackage ./pkgs/min-ed-launcher/min-ed-launcher.nix {};
    };
  };
}
