# Needed for flake-parts to work.
{ inputs, ... }:
{
  imports = [
    # https://flake.parts/options/flake-parts-modules.html
    inputs.flake-parts.flakeModules.modules
  ];

  systems = [
    "x86_64-linux"
  ];

  # Installation tooling uses the same pinned nixpkgs as the hosts.
  perSystem = { pkgs, ... }: {
    packages.nixos-anywhere = pkgs.nixos-anywhere;
  };
}
