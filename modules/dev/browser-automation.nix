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

      playwrightDriver = pkgs.playwright-driver.overrideAttrs (old: {
        passthru = old.passthru // {
          browsers = old.passthru."browsers-chromium";
        };
      });
      playwrightTest = pkgs.playwright-test.overrideAttrs (old: {
        # Replace both the browser path and its hidden string context dependency.
        installPhase =
          builtins.appendContext
            (builtins.replaceStrings
              [ (builtins.unsafeDiscardStringContext "${pkgs.playwright-driver.browsers}") ]
              [ "${playwrightDriver.browsers}" ]
              (builtins.unsafeDiscardStringContext old.installPhase)
            )
            (
              builtins.removeAttrs (builtins.getContext old.installPhase) [
                (builtins.unsafeDiscardStringContext pkgs.playwright-driver.browsers.drvPath)
              ]
            );
      });
      playwrightMcp = pkgs.playwright-mcp.override {
        playwright-driver = playwrightDriver;
        playwright-test = playwrightTest;
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
          "${playwrightMcp}/bin/playwright-mcp"
          "--cdp-endpoint"
          "http://127.0.0.1:9222"
        ];
      };
    };
}
