{ config, inputs, ... }:
let
  nixos = config.flake.modules.nixos;
  adminKeys = [
    (builtins.readFile ../../keys/servnix-admin.pub)
  ];
in
{
  flake.nixosConfigurations.servnix = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      nixos.base
      nixos.servnix-hardware

      {
        networking.hostName = "servnix";
        nixpkgs.hostPlatform = "x86_64-linux";

        # Match the interface name used by Hetzner's guest configuration.
        networking.usePredictableInterfaceNames = false;
        networking.useDHCP = false;
        networking.interfaces.eth0 = {
          useDHCP = true;
          ipv6.addresses = [
            {
              address = "2a01:4f8:1c16:994b::1";
              prefixLength = 64;
            }
          ];
        };
        networking.defaultGateway6 = {
          address = "fe80::1";
          interface = "eth0";
        };

        services.qemuGuest.enable = true;
        services.openssh = {
          enable = true;
          settings = {
            PermitRootLogin = "prohibit-password";
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
          };
        };
        networking.firewall.enable = true;
        users.users.root.openssh.authorizedKeys.keys = adminKeys;
        users.users.ondrej.openssh.authorizedKeys.keys = adminKeys;
        # Passwordless administration for the SSH-key-only administrator account.
        security.sudo.wheelNeedsPassword = false;

        zramSwap.enable = true;

        # Initial NixOS installation version; keep this on later upgrades.
        system.stateVersion = "26.11";
      }
    ];
  };
}
