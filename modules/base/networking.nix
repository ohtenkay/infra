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

      services.nordvpn.enable = true;
      networking.firewall.checkReversePath = "loose";

      environment.systemPackages = with pkgs; [
        wifitui
      ];
    };
}
