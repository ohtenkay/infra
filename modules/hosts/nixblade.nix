# Declares the nixblade NixOS configuration by composing named modules.
{
  config,
  inputs,
  lib,
  ...
}:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.nixosConfigurations.nixblade = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      nixos.base
      nixos.desktop
      nixos.dev
      nixos.shell
      nixos.stylix
      nixos.nixblade-hardware
      nixos.nvidia
      nixos.neovim
      nixos.docker

      {
        networking.hostName = "nixblade";
        nixpkgs.hostPlatform = "x86_64-linux";

        my.hardware.nvidia.enable = lib.mkDefault true;

        specialisation = {
          battery-life.configuration = {
            my.hardware.nvidia.enable = lib.mkForce false;
            system.nixos.tags = [ "battery-life" ];
          };
        };

        # https://nixos.org/nixos/options.html
        system.stateVersion = "25.11";
      }
    ];
  };
}
