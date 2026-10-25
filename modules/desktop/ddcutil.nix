{ ... }:
{
  flake.modules.nixos.ddcutil =
    { pkgs, ... }:
    {
      hardware.i2c.enable = true;

      environment.systemPackages = with pkgs; [
        ddcutil
      ];
    };
}
