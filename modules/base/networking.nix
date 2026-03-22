{ ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      networking.networkmanager = {
        enable = true;
        plugins = with pkgs; [
          networkmanager-openvpn
        ];
      };

      environment.systemPackages = with pkgs; [
        wifitui
      ];
    };
}
