{ ... }:
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    let
      palantirJavaFormatVersion = "2.90.0";
      palantirJavaFormatNative =
        if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then
          {
            url = "https://repo1.maven.org/maven2/com/palantir/javaformat/palantir-java-format-native/${palantirJavaFormatVersion}/palantir-java-format-native-${palantirJavaFormatVersion}-nativeImage-linux-glibc_x86-64.bin";
            hash = "sha256-BU3rzDRU/LjFE1Jn0O0GkK1HTaNvXufJSuqWZQh2mdE=";
          }
        else if pkgs.stdenv.hostPlatform.system == "aarch64-linux" then
          {
            url = "https://repo1.maven.org/maven2/com/palantir/javaformat/palantir-java-format-native/${palantirJavaFormatVersion}/palantir-java-format-native-${palantirJavaFormatVersion}-nativeImage-linux-glibc_aarch64.bin";
            hash = "sha256-kDWDDvHflvki0Vxt4RaO0Gz2dcqfSolKpVKEKDT9iGA=";
          }
        else
          throw "palantir-java-format is only configured for Linux x86_64/aarch64";

      palantirJavaFormat = pkgs.stdenvNoCC.mkDerivation {
        pname = "palantir-java-format";
        version = palantirJavaFormatVersion;
        src = pkgs.fetchurl palantirJavaFormatNative;
        dontUnpack = true;
        nativeBuildInputs = [ pkgs.autoPatchelfHook ];
        buildInputs = [
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
        ];
        installPhase = ''
          runHook preInstall
          install -Dm755 "$src" "$out/bin/palantir-java-format"
          runHook postInstall
        '';
      };

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
        (jdt-language-server.override { jdk = pkgs.jdk25; })
        lombok
        palantirJavaFormat
      ];
    };
}
