{ ... }:
{
  flake.modules.nixos.laptop-networking =
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

      users.users.ondrej.extraGroups = [
        "networkmanager"
        "nordvpn"
      ];

      environment.systemPackages = with pkgs; [
        wifitui
      ];
    };
}
