{ ... }:
{
  #   flake.modules.nixos.dev =
  #     { pkgs, ... }:
  #     let
  #       androidComposition = pkgs.androidenv.composeAndroidPackages {
  #         cmdLineToolsVersion = "8.0";
  #         platformToolsVersion = "35.0.2";
  #         buildToolsVersions = [
  #           "34.0.0"
  #           "35.0.0"
  #         ];
  #         platformVersions = [
  #           "34"
  #           "35"
  #         ];
  #         # emulator = true;
  #         includeSystemImages = true;
  #         systemImageTypes = [ "google_apis_playstore" ];
  #         abiVersions = [ "x86_64" ];
  #         extraLicenses = [
  #           "android-sdk-license"
  #           "android-sdk-preview-license"
  #           "android-googletv-license"
  #           "android-sdk-arm-dbt-license"
  #           "google-gdk-license"
  #           "intel-android-extra-license"
  #           "intel-android-sysimage-license"
  #           "mips-android-sysimage-license"
  #         ];
  #       };
  #       androidSdk = androidComposition.androidsdk;
  #     in
  #     {
  #       environment.systemPackages = with pkgs; [
  #         flutter
  #         dart
  #         androidSdk
  #         android-tools
  #
  #         # flutter linux desktop dependencies
  #         clang
  #         cmake
  #         ninja
  #         pkg-config
  #         gtk3
  #         glib
  #         pcre2
  #         libepoxy
  #         libX11
  #       ];
  #
  #       users.users.ondrej.extraGroups = [
  #         "kvm"
  #       ];
  #
  #       environment.variables = {
  #         ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
  #         ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
  #         CHROME_EXECUTABLE = "${pkgs.brave}/bin/brave";
  #       };
  #     };
}
