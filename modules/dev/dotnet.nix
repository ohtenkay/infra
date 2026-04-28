{ ... }:
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        dotnet-sdk
        fsautocomplete
        fantomas
      ];

      environment.variables = {
        DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      };
    };
}
