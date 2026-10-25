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
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.nixos-anywhere = pkgs.nixos-anywhere;
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          terraform
          jq
          git
          openssh
          python3
        ];
      };
    };
}
