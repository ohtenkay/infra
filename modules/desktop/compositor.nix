{ inputs, lib, ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      imports = [ inputs.niri.nixosModules.niri ];
      nixpkgs.overlays = [ inputs.niri.overlays.niri ];

      programs.firefox.enable = true;
      programs.niri.enable = true;

      environment.variables.BROWSER = "firefox";

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "niri-session";
            user = "ondrej";
          };
        };
      };

      environment.systemPackages = with pkgs; [
        xwayland-satellite
        fuzzel
      ];

      home-manager.users.ondrej = {
        programs.kitty = {
          enable = true;
          settings = {
            hide_window_decorations = true;
            shell = "zsh";
            cursor_trail = 3;
            enable_audio_bell = false;
            background_opacity = lib.mkForce "0.90";
          };
        };

        programs.niri.settings = {
          prefer-no-csd = true;

          outputs = {
            "HDMI-A-1" = {
              mode = {
                width = 2560;
                height = 1440;
                refresh = 144.006;
              };
              scale = 1.25;
            };
            "eDP-1" = {
              scale = 1.25;
            };
          };

          layout = {
            gaps = 0;
            border.enable = false;
            focus-ring.enable = false;
          };

          environment."NIXOS_OZONE_WL" = "1";

          binds = {
            # Terminal
            "Mod+Return".action.spawn = "kitty";

            # Hotkey overlay
            "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];

            # App launcher
            "Mod+D" = {
              hotkey-overlay.title = "Run an Application: fuzzel";
              action.spawn = "fuzzel";
            };

            # Screen locker
            "Super+Alt+L" = {
              hotkey-overlay.title = "Lock the Screen: swaylock";
              action.spawn = "swaylock";
            };

            # Screen reader toggle
            "Super+Alt+S" = {
              allow-when-locked = true;
              hotkey-overlay.hidden = true;
              action.spawn-sh = "pkill orca || exec orca";
            };

            # Volume keys
            "XF86AudioRaiseVolume" = {
              allow-when-locked = true;
              action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
            };
            "XF86AudioLowerVolume" = {
              allow-when-locked = true;
              action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
            };
            "XF86AudioMute" = {
              allow-when-locked = true;
              action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            };
            "XF86AudioMicMute" = {
              allow-when-locked = true;
              action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            };

            # Media keys
            "XF86AudioPlay" = {
              allow-when-locked = true;
              action.spawn-sh = "playerctl play-pause";
            };
            "XF86AudioStop" = {
              allow-when-locked = true;
              action.spawn-sh = "playerctl stop";
            };
            "XF86AudioPrev" = {
              allow-when-locked = true;
              action.spawn-sh = "playerctl previous";
            };
            "XF86AudioNext" = {
              allow-when-locked = true;
              action.spawn-sh = "playerctl next";
            };

            # Brightness keys
            "XF86MonBrightnessUp" = {
              allow-when-locked = true;
              action.spawn = [
                "brightnessctl"
                "--class=backlight"
                "set"
                "+10%"
              ];
            };
            "XF86MonBrightnessDown" = {
              allow-when-locked = true;
              action.spawn = [
                "brightnessctl"
                "--class=backlight"
                "set"
                "10%-"
              ];
            };

            # Overview
            "Mod+O" = {
              repeat = false;
              action.toggle-overview = [ ];
            };

            # Close window
            "Mod+Q" = {
              repeat = false;
              action.close-window = [ ];
            };

            # Focus columns/windows
            "Mod+H".action.focus-column-left = [ ];
            "Mod+J".action.focus-window-down = [ ];
            "Mod+K".action.focus-window-up = [ ];
            "Mod+L".action.focus-column-right = [ ];

            # Move columns/windows
            "Mod+Ctrl+Left".action.move-column-left = [ ];
            "Mod+Ctrl+Down".action.move-window-down = [ ];
            "Mod+Ctrl+Up".action.move-window-up = [ ];
            "Mod+Ctrl+Right".action.move-column-right = [ ];
            "Mod+Ctrl+H".action.move-column-left = [ ];
            "Mod+Ctrl+J".action.move-window-down = [ ];
            "Mod+Ctrl+K".action.move-window-up = [ ];
            "Mod+Ctrl+L".action.move-column-right = [ ];

            # Focus first/last column
            "Mod+Home".action.focus-column-first = [ ];
            "Mod+End".action.focus-column-last = [ ];
            "Mod+Ctrl+Home".action.move-column-to-first = [ ];
            "Mod+Ctrl+End".action.move-column-to-last = [ ];

            # Focus monitor
            "Mod+Shift+Left".action.focus-monitor-left = [ ];
            "Mod+Shift+Down".action.focus-monitor-down = [ ];
            "Mod+Shift+Up".action.focus-monitor-up = [ ];
            "Mod+Shift+Right".action.focus-monitor-right = [ ];
            "Mod+Shift+H".action.focus-monitor-left = [ ];
            "Mod+Shift+J".action.focus-monitor-down = [ ];
            "Mod+Shift+K".action.focus-monitor-up = [ ];
            "Mod+Shift+L".action.focus-monitor-right = [ ];

            # Move column to monitor
            "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [ ];
            "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [ ];
            "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [ ];
            "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [ ];
            "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [ ];
            "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [ ];
            "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [ ];
            "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [ ];

            # Focus workspace up/down
            "Mod+Page_Down".action.focus-workspace-down = [ ];
            "Mod+Page_Up".action.focus-workspace-up = [ ];
            "Mod+U".action.focus-workspace-down = [ ];
            "Mod+I".action.focus-workspace-up = [ ];
            "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [ ];
            "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [ ];
            "Mod+Ctrl+U".action.move-column-to-workspace-down = [ ];
            "Mod+Ctrl+I".action.move-column-to-workspace-up = [ ];

            # Move workspace up/down
            "Mod+Shift+Page_Down".action.move-workspace-down = [ ];
            "Mod+Shift+Page_Up".action.move-workspace-up = [ ];
            "Mod+Shift+U".action.move-workspace-down = [ ];
            "Mod+Shift+I".action.move-workspace-up = [ ];

            # Mouse wheel workspace switching
            "Mod+WheelScrollDown" = {
              cooldown-ms = 150;
              action.focus-workspace-down = [ ];
            };
            "Mod+WheelScrollUp" = {
              cooldown-ms = 150;
              action.focus-workspace-up = [ ];
            };
            "Mod+Ctrl+WheelScrollDown" = {
              cooldown-ms = 150;
              action.move-column-to-workspace-down = [ ];
            };
            "Mod+Ctrl+WheelScrollUp" = {
              cooldown-ms = 150;
              action.move-column-to-workspace-up = [ ];
            };

            # Mouse wheel column focus
            "Mod+WheelScrollRight".action.focus-column-right = [ ];
            "Mod+WheelScrollLeft".action.focus-column-left = [ ];
            "Mod+Ctrl+WheelScrollRight".action.move-column-right = [ ];
            "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [ ];

            # Shift+wheel column focus
            "Mod+Shift+WheelScrollDown".action.focus-column-right = [ ];
            "Mod+Shift+WheelScrollUp".action.focus-column-left = [ ];
            "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = [ ];
            "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = [ ];

            # Focus workspace by number
            "Mod+1".action.focus-workspace = 1;
            "Mod+2".action.focus-workspace = 2;
            "Mod+3".action.focus-workspace = 3;
            "Mod+4".action.focus-workspace = 4;
            "Mod+5".action.focus-workspace = 5;
            "Mod+6".action.focus-workspace = 6;
            "Mod+7".action.focus-workspace = 7;
            "Mod+8".action.focus-workspace = 8;
            "Mod+9".action.focus-workspace = 9;

            # Move column to workspace by number
            "Mod+Ctrl+1".action.move-column-to-workspace = 1;
            "Mod+Ctrl+2".action.move-column-to-workspace = 2;
            "Mod+Ctrl+3".action.move-column-to-workspace = 3;
            "Mod+Ctrl+4".action.move-column-to-workspace = 4;
            "Mod+Ctrl+5".action.move-column-to-workspace = 5;
            "Mod+Ctrl+6".action.move-column-to-workspace = 6;
            "Mod+Ctrl+7".action.move-column-to-workspace = 7;
            "Mod+Ctrl+8".action.move-column-to-workspace = 8;
            "Mod+Ctrl+9".action.move-column-to-workspace = 9;

            # Consume/expel windows
            "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
            "Mod+BracketRight".action.consume-or-expel-window-right = [ ];
            "Mod+Comma".action.consume-window-into-column = [ ];
            "Mod+Period".action.expel-window-from-column = [ ];

            # Column/window sizing
            "Mod+R".action.switch-preset-column-width = [ ];
            "Mod+Shift+R".action.switch-preset-window-height = [ ];
            "Mod+Ctrl+R".action.reset-window-height = [ ];
            "Mod+F".action.maximize-column = [ ];
            "Mod+Shift+F".action.fullscreen-window = [ ];
            "Mod+Ctrl+F".action.expand-column-to-available-width = [ ];

            # Centering
            "Mod+C".action.center-column = [ ];
            "Mod+Ctrl+C".action.center-visible-columns = [ ];

            # Width/height adjustments
            "Mod+Minus".action.set-column-width = "-10%";
            "Mod+Equal".action.set-column-width = "+10%";
            "Mod+Shift+Minus".action.set-window-height = "-10%";
            "Mod+Shift+Equal".action.set-window-height = "+10%";

            # Floating windows
            "Mod+V".action.toggle-window-floating = [ ];
            "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [ ];

            # Tabbed display
            "Mod+W".action.toggle-column-tabbed-display = [ ];

            # Screenshots
            "Print".action.screenshot = [ ];
            "Ctrl+Print".action.screenshot-screen = [ ];
            "Alt+Print".action.screenshot-window = [ ];

            # Keyboard shortcuts inhibit
            "Mod+Escape" = {
              allow-inhibiting = false;
              action.toggle-keyboard-shortcuts-inhibit = [ ];
            };

            # Quit
            "Mod+Shift+E".action.quit = [ ];
            "Ctrl+Alt+Delete".action.quit = [ ];

            # Power off monitors
            "Mod+Shift+P".action.power-off-monitors = [ ];
          };
        };
      };
    };
}
