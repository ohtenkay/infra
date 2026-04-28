{ ... }:
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        eslint_d
        prettierd
        typescript-language-server
        tailwindcss-language-server
      ];
    };
}
