{ ... }:
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nodejs_25
        home-manager

        python3

        opencode
        bitwarden-desktop
        qbittorrent
        brave

        lazysql

        vlc

        yt-dlp
        nautilus
        ntfs3g
        udisks2
        gvfs
        kdePackages.dolphin
        kdePackages.kio-extras
        thunar
      ];
    };
}
