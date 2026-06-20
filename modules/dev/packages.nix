{ ... }:
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nodejs_24
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

        mermaid-cli
        mupdf

        qbittorrent
        terraform
        terraform-ls
        lemminx

        btop

        libreoffice
        zathura

        plantuml
        graphviz
        inotify-tools
        ripgrep-all
        qpdf
        obs-studio
        ffmpeg

        transmission_4-qt

        devenv
        codex
        dust
      ];
    };
}
