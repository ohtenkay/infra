{ ... }:
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    let
      chromiumPlaywright = pkgs.writeShellApplication {
        name = "chromium-playwright";
        runtimeInputs = [ pkgs.chromium ];
        text = ''
          exec chromium \
            --remote-debugging-port=9222 \
            --user-data-dir="''${XDG_DATA_HOME:-$HOME/.local/share}/chromium-playwright" \
            "$@"
        '';
      };

      chromiumPlaywrightDesktop = pkgs.makeDesktopItem {
        name = "chromium-playwright";
        desktopName = "Chromium (Playwright)";
        comment = "Chromium with local Playwright debugging enabled";
        exec = "${chromiumPlaywright}/bin/chromium-playwright %U";
        icon = "chromium";
        categories = [ "Development" ];
      };
    in
    {
      environment.systemPackages = [
        chromiumPlaywright
        chromiumPlaywrightDesktop
      ];

      home-manager.users.ondrej.programs.opencode.settings.mcp.playwright = {
        type = "local";
        enabled = false;
        command = [
          "${pkgs.playwright-mcp}/bin/playwright-mcp"
          "--cdp-endpoint"
          "http://127.0.0.1:9222"
        ];
      };
    };
}
