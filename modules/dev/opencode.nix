{ ... }:
{
  flake.modules.nixos.dev =
    { ... }:
    {
      home-manager.users.ondrej.programs.opencode = {
        enable = true;

        settings.permission = {
          read."/nix/store/**" = "allow";
          external_directory."/nix/store/**" = "allow";
        };
      };
    };
}
