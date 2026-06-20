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

        programs.noctalia = {
          enable = true;

          settings = {
            shell = {
              corner_radius_scale = 1;
              font_family = "JetBrainsMono Nerd Font Mono";
              niri_overview_type_to_launch_enabled = true;
            };

            # shell.animation.speed = 1;

            theme = {
              mode = lib.mkForce "dark";
              source = lib.mkForce "community";
              community_palette = "Kanagawa Dragon";
            };

            # notification = {
            #   enable_daemon = true;
            #   position = "bottom_right";
            #   background_opacity = 0.97;
            # };
            #
            bar.main = {
              #   position = "top";
              #   background_opacity = 0.93;
              margin_ends = 5;
              margin_edge = 5;
              margin_opposite_edge = 5;
              #   radius = 12;
              #   start = [
              #     "launcher"
              #     "clock"
              #   ];
              #   center = [ "workspaces" ];
              #   end = [
              #     "tray"
              #     "notifications"
              #     "battery"
              #     "volume"
              #     "brightness"
              #     "network"
              #     "bluetooth"
              #     "control-center"
              #   ];
            };

            # widget.workspaces = {
            #   display = "none";
            #   hide_when_empty = false;
            # };
          };
        };
      };
    };
}
