{ ... }:
{
  flake.modules.nixos.base = {
    time.timeZone = "Europe/Prague";
    i18n.defaultLocale = "en_US.UTF-8";
  };
}
