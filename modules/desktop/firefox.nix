{ ... }:
{
  flake.modules.nixos.firefox = {
    programs.firefox.enable = true;
    environment.variables.BROWSER = "firefox";
  };
}
