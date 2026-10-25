{ inputs, ... }:
{
  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
    };

    home-manager.users.ondrej.home = {
      username = "ondrej";
      homeDirectory = "/home/ondrej";
      stateVersion = "25.11";
    };
  };
}
