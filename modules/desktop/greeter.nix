{ ... }:
{
  flake.modules.nixos.desktop = {
    services.displayManager.noctalia-greeter = {
      enable = true;
      passwordlessSyncUsers = [ "ondrej" ];

      settings = {
        session.default = "niri";
        user.default = "ondrej";

        keyboard = {
          layout = "us";
          numlock = true;
        };
      };
    };
  };
}
