{ ... }:
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    let
      mavenWithJDK25 = pkgs.writeShellScriptBin "mvn" ''
        export JAVA_HOME=${pkgs.jdk25}
        export PATH="$JAVA_HOME/bin:$PATH"
        exec ${pkgs.maven}/bin/mvn "$@"
      '';
    in
    {
      environment.systemPackages = with pkgs; [
        jdk25
        mavenWithJDK25
        jdt-language-server
        lombok
      ];
    };
}
