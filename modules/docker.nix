{ inputs, ... }:
{
  flake.modules.nixos.docker =
    { pkgs, ... }:
    {
      virtualisation.docker.enable = true;
      users.users.ondrej.extraGroups = [ "docker" ];

      home-manager.users.ondrej.programs = {
        lazydocker = {
          enable = true;
        };
      };

      environment.systemPackages = with pkgs; [
        dive
        openshift
      ];
    };
}
