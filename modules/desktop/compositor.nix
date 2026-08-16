{ lib, ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      programs.firefox.enable = true;
      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };

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
        wl-mirror
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
            tab_bar_edge = "bottom";
            tab_title_template = "{title}";
          };

          keybindings = {
            "ctrl+shift+t" = "new_tab_with_cwd";
            "ctrl+alt+1" = "goto_tab 1";
            "ctrl+alt+2" = "goto_tab 2";
            "ctrl+alt+3" = "goto_tab 3";
            "ctrl+alt+4" = "goto_tab 4";
            "ctrl+alt+5" = "goto_tab 5";
            "ctrl+alt+6" = "goto_tab 6";
            "ctrl+alt+7" = "goto_tab 7";
            "ctrl+alt+8" = "goto_tab 8";
            "ctrl+alt+9" = "goto_tab 9";

            "ctrl+alt+s" = "save_as_session --use-foreground-process --base-dir ~/.local/share/kitty/sessions";
            "ctrl+alt+p" = "goto_session ~/.local/share/kitty/sessions";
            "ctrl+alt+w" = "close_session .";
          };

        };

        home.file.".local/share/kitty/sessions/.keep".text = "";

        wayland.windowManager.niri = {
          enable = true;
          package = pkgs.niri;
          systemd.enable = false;
          portalPackage = null;
          xwaylandSatellitePackage = null;

          settings = {
            prefer-no-csd = { };

            debug.honor-xdg-activation-with-invalid-serial = { };

            layout = {
              gaps = 0;
              border.off = { };
              focus-ring.off = { };
            };

            environment."NIXOS_OZONE_WL" = "1";

            _children = [
              {
                output = {
                  _args = [ "HDMI-A-1" ];
                  focus-at-startup = { };
                  mode = "2560x1440";
                  # mode = "2560x1440@144.006";
                  # scale = 1.25;
                };
              }
              {
                output = {
                  _args = [ "eDP-1" ];
                  scale = 1.25;
                };
              }
              {
                workspace = {
                  _args = [ "1" ];
                  open-on-output = "HDMI-A-1";
                };
              }
              {
                workspace = {
                  _args = [ "2" ];
                  open-on-output = "HDMI-A-1";
                };
              }
              { spawn-at-startup._args = [ "noctalia" ]; }
              { spawn-at-startup._args = [ "kitty" ]; }
              { spawn-at-startup._args = [ "firefox" ]; }
              {
                window-rule._children = [
                  {
                    match._props = {
                      app-id = "^kitty$";
                      at-startup = true;
                    };
                  }
                  { open-on-workspace = "1"; }
                  { open-maximized = true; }
                ];
              }
              {
                window-rule._children = [
                  {
                    match._props = {
                      app-id = "^firefox$";
                      at-startup = true;
                    };
                  }
                  { open-on-workspace = "2"; }
                ];
              }
              {
                window-rule._children = [
                  {
                    match._props.app-id = "^dev\\.noctalia\\.Noctalia\\.Settings$";
                  }
                  { open-floating = true; }
                  { default-column-width.fixed = 1080; }
                  { default-window-height.fixed = 920; }
                ];
              }
              {
                window-rule._children = [
                  {
                    match._props = {
                      app-id = "^Emulator$";
                      title = "^Emulator$";
                    };
                  }
                  { open-floating = false; }
                ];
              }
            ];

            animations.workspace-switch.off = { };

            binds = {
              # Terminal
              "Mod+Return".spawn = [ "kitty" ];

              # Hotkey overlay
              "Mod+Shift+Slash".show-hotkey-overlay = { };

              # App launcher
              "Mod+D" = {
                _props.hotkey-overlay-title = "Run an Application: fuzzel";
                spawn = [ "fuzzel" ];
              };

              # Screen locker
              "Super+Alt+L" = {
                _props.hotkey-overlay-title = "Lock the Screen: swaylock";
                spawn = [ "swaylock" ];
              };

              # Screen reader toggle
              "Super+Alt+S" = {
                _props = {
                  allow-when-locked = true;
                  hotkey-overlay-title = null;
                };
                spawn-sh = [ "pkill orca || exec orca" ];
              };

              # Volume keys
              "XF86AudioRaiseVolume" = {
                _props.allow-when-locked = true;
                spawn-sh = [ "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0" ];
              };
              "XF86AudioLowerVolume" = {
                _props.allow-when-locked = true;
                spawn-sh = [ "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-" ];
              };
              "XF86AudioMute" = {
                _props.allow-when-locked = true;
                spawn-sh = [ "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" ];
              };
              "XF86AudioMicMute" = {
                _props.allow-when-locked = true;
                spawn-sh = [ "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ];
              };

              # Media keys
              "XF86AudioPlay" = {
                _props.allow-when-locked = true;
                spawn-sh = [ "playerctl play-pause" ];
              };
              "XF86AudioStop" = {
                _props.allow-when-locked = true;
                spawn-sh = [ "playerctl stop" ];
              };
              "XF86AudioPrev" = {
                _props.allow-when-locked = true;
                spawn-sh = [ "playerctl previous" ];
              };
              "XF86AudioNext" = {
                _props.allow-when-locked = true;
                spawn-sh = [ "playerctl next" ];
              };

              # Brightness keys
              "XF86MonBrightnessUp" = {
                _props.allow-when-locked = true;
                spawn = [
                  "brightnessctl"
                  "--class=backlight"
                  "set"
                  "+10%"
                ];
              };
              "XF86MonBrightnessDown" = {
                _props.allow-when-locked = true;
                spawn = [
                  "brightnessctl"
                  "--class=backlight"
                  "set"
                  "10%-"
                ];
              };

              # Overview
              "Mod+O" = {
                _props.repeat = false;
                toggle-overview = { };
              };

              # Close window
              "Mod+Q" = {
                _props.repeat = false;
                close-window = { };
              };

              # Focus columns/windows
              "Mod+H".focus-column-left = { };
              "Mod+J".focus-window-down = { };
              "Mod+K".focus-window-up = { };
              "Mod+L".focus-column-right = { };

              # Move columns/windows
              "Mod+Ctrl+Left".move-column-left = { };
              "Mod+Ctrl+Down".move-window-down = { };
              "Mod+Ctrl+Up".move-window-up = { };
              "Mod+Ctrl+Right".move-column-right = { };
              "Mod+Ctrl+H".move-column-left = { };
              "Mod+Ctrl+J".move-window-down = { };
              "Mod+Ctrl+K".move-window-up = { };
              "Mod+Ctrl+L".move-column-right = { };

              # Focus first/last column
              "Mod+Home".focus-column-first = { };
              "Mod+End".focus-column-last = { };
              "Mod+Ctrl+Home".move-column-to-first = { };
              "Mod+Ctrl+End".move-column-to-last = { };

              # Focus monitor
              "Mod+Shift+Left".focus-monitor-left = { };
              "Mod+Shift+Down".focus-monitor-down = { };
              "Mod+Shift+Up".focus-monitor-up = { };
              "Mod+Shift+Right".focus-monitor-right = { };
              "Mod+Shift+H".focus-monitor-left = { };
              "Mod+Shift+J".focus-monitor-down = { };
              "Mod+Shift+K".focus-monitor-up = { };
              "Mod+Shift+L".focus-monitor-right = { };

              # Move column to monitor
              "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = { };
              "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = { };
              "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = { };
              "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = { };
              "Mod+Shift+Ctrl+H".move-column-to-monitor-left = { };
              "Mod+Shift+Ctrl+J".move-column-to-monitor-down = { };
              "Mod+Shift+Ctrl+K".move-column-to-monitor-up = { };
              "Mod+Shift+Ctrl+L".move-column-to-monitor-right = { };

              # Focus workspace up/down
              "Mod+Page_Down".focus-workspace-down = { };
              "Mod+Page_Up".focus-workspace-up = { };
              "Mod+U".focus-workspace-down = { };
              "Mod+I".focus-workspace-up = { };
              "Mod+Ctrl+Page_Down".move-column-to-workspace-down = { };
              "Mod+Ctrl+Page_Up".move-column-to-workspace-up = { };
              "Mod+Ctrl+U".move-column-to-workspace-down = { };
              "Mod+Ctrl+I".move-column-to-workspace-up = { };

              # Move workspace up/down
              "Mod+Shift+Page_Down".move-workspace-down = { };
              "Mod+Shift+Page_Up".move-workspace-up = { };
              "Mod+Shift+U".move-workspace-down = { };
              "Mod+Shift+I".move-workspace-up = { };

              # Mouse wheel workspace switching
              "Mod+WheelScrollDown" = {
                _props.cooldown-ms = 150;
                focus-workspace-down = { };
              };
              "Mod+WheelScrollUp" = {
                _props.cooldown-ms = 150;
                focus-workspace-up = { };
              };
              "Mod+Ctrl+WheelScrollDown" = {
                _props.cooldown-ms = 150;
                move-column-to-workspace-down = { };
              };
              "Mod+Ctrl+WheelScrollUp" = {
                _props.cooldown-ms = 150;
                move-column-to-workspace-up = { };
              };

              # Mouse wheel column focus
              "Mod+WheelScrollRight".focus-column-right = { };
              "Mod+WheelScrollLeft".focus-column-left = { };
              "Mod+Ctrl+WheelScrollRight".move-column-right = { };
              "Mod+Ctrl+WheelScrollLeft".move-column-left = { };

              # Shift+wheel column focus
              "Mod+Shift+WheelScrollDown".focus-column-right = { };
              "Mod+Shift+WheelScrollUp".focus-column-left = { };
              "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = { };
              "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = { };

              # Focus workspace by number
              "Mod+1".focus-workspace = "1";
              "Mod+2".focus-workspace = "2";
              "Mod+3".focus-workspace = 3;
              "Mod+4".focus-workspace = 4;
              "Mod+5".focus-workspace = 5;
              "Mod+6".focus-workspace = 6;
              "Mod+7".focus-workspace = 7;
              "Mod+8".focus-workspace = 8;
              "Mod+9".focus-workspace = 9;

              # Move column to workspace by number
              "Mod+Ctrl+1".move-column-to-workspace = "1";
              "Mod+Ctrl+2".move-column-to-workspace = "2";
              "Mod+Ctrl+3".move-column-to-workspace = 3;
              "Mod+Ctrl+4".move-column-to-workspace = 4;
              "Mod+Ctrl+5".move-column-to-workspace = 5;
              "Mod+Ctrl+6".move-column-to-workspace = 6;
              "Mod+Ctrl+7".move-column-to-workspace = 7;
              "Mod+Ctrl+8".move-column-to-workspace = 8;
              "Mod+Ctrl+9".move-column-to-workspace = 9;

              # Consume/expel windows
              "Mod+BracketLeft".consume-or-expel-window-left = { };
              "Mod+BracketRight".consume-or-expel-window-right = { };
              "Mod+Comma".consume-window-into-column = { };
              "Mod+Period".expel-window-from-column = { };

              # Column/window sizing
              "Mod+R".switch-preset-column-width = { };
              "Mod+Shift+R".switch-preset-window-height = { };
              "Mod+Ctrl+R".reset-window-height = { };
              "Mod+F".maximize-column = { };
              "Mod+Shift+F".fullscreen-window = { };
              "Mod+Ctrl+F".expand-column-to-available-width = { };

              # Centering
              "Mod+C".center-column = { };
              "Mod+Ctrl+C".center-visible-columns = { };

              # Width/height adjustments
              "Mod+Minus".set-column-width = "-10%";
              "Mod+Equal".set-column-width = "+10%";
              "Mod+Shift+Minus".set-window-height = "-10%";
              "Mod+Shift+Equal".set-window-height = "+10%";

              # Floating windows
              "Mod+V".toggle-window-floating = { };
              "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };

              # Tabbed display
              "Mod+W".toggle-column-tabbed-display = { };

              # Screenshots
              "Mod+P".screenshot = { };
              "Ctrl+Print".screenshot-screen = { };
              "Alt+Print".screenshot-window = { };

              # Keyboard shortcuts inhibit
              "Mod+Escape" = {
                _props.allow-inhibiting = false;
                toggle-keyboard-shortcuts-inhibit = { };
              };

              # Quit
              "Mod+Shift+E".quit = { };
              "Ctrl+Alt+Delete".quit = { };

              # Power off monitors
              "Mod+Shift+P".power-off-monitors = { };
            };
          };
        };
      };
    };
}
