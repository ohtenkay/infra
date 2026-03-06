{ inputs, ... }:
let
  # TODO: This is a bit hacky, explore other options
  flakeRoot = "/home/ondrej/infra";
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      # Make flakeRoot available to all NixOS modules as a module argument.
      _module.args.flakeRoot = flakeRoot;

      # Required for zsh to be a valid login shell.
      programs.zsh.enable = true;

      users.users.ondrej = {
        isNormalUser = true;
        description = "ondrej";
        shell = pkgs.zsh;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        # Make flakeRoot available to all Home Manager modules as a module argument.
        extraSpecialArgs = { inherit flakeRoot; };
      };

      home-manager.users.ondrej = {
        home = {
          username = "ondrej";
          homeDirectory = "/home/ondrej";
          stateVersion = "25.11";
        };
      };
    };
}
