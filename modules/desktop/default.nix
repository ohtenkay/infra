{ config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.modules.nixos.desktop = {
    imports = [
      nixos.niri
      nixos.kitty
      nixos.firefox
      nixos.nordvpn-desktop
      nixos.greeter
      nixos.audio
      nixos.bluetooth
      nixos.ddcutil
      nixos.noctalia
    ];
  };
}
