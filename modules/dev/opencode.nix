{ ... }:
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    let
      # Temporary pin: OpenCode 1.18.30 crashes while assembling the system prompt.
      opencode = pkgs.stdenv.mkDerivation {
        pname = "opencode";
        version = "1.18.20";

        src = pkgs.fetchurl {
          url = "https://github.com/anomalyco/opencode/releases/download/v1.18.20/opencode-linux-x64-baseline.tar.gz";
          hash = "sha256-NUdE8uSUtBLl1FcH7eJUu5nxEmD4RNwmCW++1d8DL3w=";
        };

        nativeBuildInputs = [ pkgs.autoPatchelfHook ];
        sourceRoot = ".";
        dontStrip = true;

        installPhase = ''
          runHook preInstall
          install -Dm755 opencode $out/bin/opencode
          runHook postInstall
        '';

        meta.mainProgram = "opencode";
      };
    in
    {
      home-manager.users.ondrej.programs.opencode = {
        enable = true;
        package = opencode;

        settings.permission = {
          read."/nix/store/**" = "allow";
          external_directory."/nix/store/**" = "allow";
        };
      };
    };
}
