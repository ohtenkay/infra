{ ... }:
{
  flake.modules.nixos.dev =
    { ... }:
    {
      programs.steam.enable = true;
      programs.gamemode.enable = true;
    };
}
