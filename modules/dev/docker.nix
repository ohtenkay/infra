{ ... }:
{
  flake.modules.nixos.docker =
    { ... }:
    {
      virtualisation.docker.enable = true;
      users.users.ondrej.extraGroups = [ "docker" ];

      home-manager.users.ondrej.programs = {
        lazydocker = {
          enable = true;
        };
      };
    };
}
