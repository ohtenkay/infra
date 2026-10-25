{ ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      # Required for zsh to be a valid login shell.
      programs.zsh.enable = true;

      users.users.ondrej = {
        isNormalUser = true;
        description = "ondrej";
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
        ];
      };
    };
}
