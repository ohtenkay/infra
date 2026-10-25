{ ... }:
{
  flake.modules.nixos.shell = {
    home-manager.users.ondrej.programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      includes = [ "~/.ssh/servnix-address.conf" ];
      settings.servnix = {
        User = "ondrej";
        IdentityFile = "~/.ssh/id_ed25519_servnix";
        IdentitiesOnly = true;
      };
    };
  };
}
