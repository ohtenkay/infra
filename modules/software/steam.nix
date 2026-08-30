{ ... }:
{
  flake.modules.nixos.software =
    { ... }:
    {
      programs.steam.enable = true;
      programs.gamemode.enable = true;
    };
}
