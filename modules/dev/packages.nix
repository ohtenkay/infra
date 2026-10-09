{ ... }:
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nodejs_24
        home-manager

        python3

        bitwarden-desktop
        qbittorrent
        brave

        lazysql

        vlc

        yt-dlp
        nautilus
        ntfs3g
        gvfs
        kdePackages.dolphin
        kdePackages.kio-extras
        thunar

        mermaid-cli
        mupdf

        qbittorrent
        terraform
        terraform-ls
        lemminx

        btop

        libreoffice

        plantuml
        graphviz
        inotify-tools
        ripgrep-all
        qpdf
        obs-studio
        ffmpeg
        localsend

        transmission_4-qt

        codex
        dust

        proton-vpn-cli
      ];

      services.udisks2.enable = true;
      security.polkit.enable = true;

      home-manager.users.ondrej.services.udiskie.enable = true;
    };
}
