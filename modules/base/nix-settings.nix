{ ... }:
{
  flake.modules.nixos.base = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.android_sdk.accept_license = true;
    nixpkgs.config.permittedInsecurePackages = [
      "electron-39.8.10"
    ];

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
