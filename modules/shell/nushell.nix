{ ... }:
{
  flake.modules.nixos.shell = {
    home-manager.users.ondrej.programs.nushell = {
      enable = true;
      shellAliases = {
        nrs = "sudo nixos-rebuild switch --flake path:/home/ondrej/infra";
        nfu = "nix flake update --flake path:/home/ondrej/infra";
      };
    };
  };
}
