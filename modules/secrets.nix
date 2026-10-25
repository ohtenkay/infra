# Agenix secrets management via the home-manager module.
# Secrets are decrypted at activation time using the user's SSH key.
{ inputs, ... }:
{
  flake.modules.nixos.user-secrets =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      home-manager.users.ondrej = {
        imports = [ inputs.agenix.homeManagerModules.default ];
        age.identityPaths = [ "/home/ondrej/.ssh/id_ed25519" ];
      };
    };
}
