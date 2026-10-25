{ ... }:
{
  flake.modules.nixos.shell = {
    home-manager.users.ondrej.programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings.servnix = {
        HostName = "2.31.56.62";
        User = "ondrej";
        IdentityFile = "~/.ssh/id_ed25519_servnix";
        IdentitiesOnly = true;
      };
    };
  };
}
