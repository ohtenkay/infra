{ lib, ... }:
{
  flake.modules.nixos.kitty = {
    home-manager.users.ondrej = {
      programs.kitty = {
        enable = true;
        settings = {
          hide_window_decorations = true;
          shell = "zsh";
          cursor_trail = 3;
          enable_audio_bell = false;
          background_opacity = lib.mkForce "0.94";
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
    };
  };
}
