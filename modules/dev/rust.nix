{ ... }:
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # rustup
        rustc
        cargo
        rust-analyzer
        rustfmt
        clippy
        cargo-outdated
      ];
    };
}
