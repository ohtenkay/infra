{ inputs, ... }:
{
  flake.modules.nixos.desktop =
    { lib, ... }:
    {
      # Prerequisites for Noctalia's wifi, bluetooth, power-profile, and battery features.
      # networking.networkmanager.enable and hardware.bluetooth.enable are already set elsewhere.
      services.upower.enable = true;
      services.power-profiles-daemon.enable = true;

      home-manager.users.ondrej = {
        imports = [ inputs.noctalia.homeModules.default ];

        programs.noctalia-shell = {
          enable = true;

          # Start Noctalia automatically via systemd after the Wayland session is ready.
          systemd.enable = true;

          settings = lib.mkForce {
            bar = {
              position = "top";
              density = "default";
              floating = true;
              backgroundOpacity = 0.93;
              widgets = {
                left = [
                  { id = "Launcher"; }
                  { id = "Clock"; }
                  # { id = "ActiveWindow"; }
                  # { id = "MediaMini"; }
                ];
                center = [
                  {
                    id = "Workspace";
                    hideUnoccupied = false;
                    labelMode = "none";
                  }
                ];
                right = [
                  { id = "Tray"; }
                  { id = "NotificationHistory"; }
                  { id = "Battery"; }
                  { id = "Volume"; }
                  { id = "Brightness"; }
                  { id = "Network"; }
                  { id = "Bluetooth"; }
                  { id = "ControlCenter"; }
                ];
              };
            };

            general = {
              radiusRatio = 1;
              animationSpeed = 1;
            };

            notifications = {
              enabled = true;
              location = "top_right";
              normalUrgencyDuration = 8;
            };

            colorSchemes = {
              useWallpaperColors = true;
              darkMode = true;
            };
          };
        };
      };
    };
}
